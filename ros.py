#!/usr/bin/env python3
import csv
import math
import sys
from time import sleep
import moveit_commander
import rospy
import copy
from moveit_commander import MoveGroupCommander
from numpy import array
import random
from ur_msgs.srv import SetIO
import numpy as np
from spatialmath import SE3
from math import pi
import socket
from numpy.linalg import norm
import pathlib
from robotics_tool_box_peter_corke_ur5e import UR5e

joint_values = []
pose_values = []
data_pos_LT = []

HIGH_VOLTAGE = 1
LOW_VOLTAGE = 0


def sampling_from_observable_task_space(
        x_low: float = 0.25,
        x_high: float = 0.55,
        y_low: float = -0.8,
        y_high: float = 0.20,
        z_low: float = 0.2,
        z_high: float = 1,
        rx_low: float = 0,
        rx_high: float = 0.3 * math.pi,
        ry_low: float = 0.1 * math.pi,
        ry_high: float = 0.8 * math.pi,
        rz_low: float = 0.1 * math.pi,
        rz_high: float = 0.8 * math.pi, offset=0.1
) -> array:
    """Sample an observable pose in task space unifromly between low and high.

    Args:
        x_low (int, optional): Defaults to 0.250.
        x_high (int, optional): Defaults to 0.500.
        y_low (int, optional): Defaults to -0.500.
        y_high (int, optional): Defaults to 0.500.
        z_low (int, optional): Defaults to 0.5.
        z_high (int, optional): Defaults to 0.800.
        rx_low (float, optional): Defaults to 0.
        rx_high (float, optional): Defaults to 0.5math.pi.
        ry_low (float, optional): Defaults to 0.1*math.pi.
        ry_high (float, optional): Defaults to 0.8*math.pi.
        rz_low (float, optional): Defaults to 0.1*math.pi.
        rz_high (float, optional): Defaults to 0.8*math.pi.
        base (bool, optional): If True, the high and low values are defined in robot base frame.Defaults to True.


    Returns:
        array: ndarray with pose per row.
    """
    x = random.uniform(x_low, x_high)
    y = random.uniform(y_low, y_high)
    z = random.uniform(z_low, z_high - offset)
    rx = random.uniform(rx_low, rx_high)
    ry = random.uniform(ry_low, ry_high)
    rz = random.uniform(rz_low, rz_high)
    pose = array([x, y, z, rx, ry, rz])

    return pose


def get_random_waypoints_new(arm, offset=0.1):
    waypoints = []
    pos_start = sampling_from_observable_task_space()

    pos_target = sampling_from_observable_task_space()

    wpose = arm.get_current_pose().pose

    wpose.position.x = pos_start[0]
    wpose.position.y = pos_start[1]
    wpose.position.z = pos_start[2]
    waypoints.append(copy.deepcopy(wpose))
    wpose.position.x = pos_start[0]
    wpose.position.y = pos_start[1]
    wpose.position.z = pos_start[2] + offset
    waypoints.append(copy.deepcopy(wpose))

    wpose.position.x = pos_target[0]
    wpose.position.y = pos_target[1]
    wpose.position.z = pos_target[2] + offset
    waypoints.append(copy.deepcopy(wpose))
    wpose.position.x = pos_target[0]
    wpose.position.y = pos_target[1]
    wpose.position.z = pos_target[2]
    waypoints.append(copy.deepcopy(wpose))
    return waypoints


def get_random_waypoints(arm, offset=0.1):
    waypoints = []
    x_start, x_target = np.random.uniform(0.2, 0.55, 2)
    y_start, y_target = np.random.uniform(-0.8, 0.1, 2)
    z_start, z_target = np.random.uniform(0.1, 1 - offset, 2)

    wpose = arm.get_current_pose().pose
    wpose.position.x = x_start
    wpose.position.y = y_start
    wpose.position.z = z_start
    waypoints.append(copy.deepcopy(wpose))
    wpose.position.x = x_start
    wpose.position.y = y_start
    wpose.position.z = z_start + offset
    waypoints.append(copy.deepcopy(wpose))

    wpose.position.x = x_target
    wpose.position.y = y_target
    wpose.position.z = z_target + offset
    waypoints.append(copy.deepcopy(wpose))
    wpose.position.x = x_target
    wpose.position.y = y_target
    wpose.position.z = z_target
    waypoints.append(copy.deepcopy(wpose))
    return waypoints


def get_plan(arm, waypoints, eef_step=0.01):  # robot.get_current_state()

    (plan_cart, fraction) = arm.compute_cartesian_path(
        waypoints,  # waypoints to follow
        eef_step,  # eef_step
        0.0  # jump_threshold
    )
    plan_joint = plan_cart
    while len(plan_joint.joint_trajectory.points) > len(waypoints) + 1:
        (plan_joint, fraction_2) = arm.compute_cartesian_path(
            waypoints,  # waypoints to follow
            eef_step,  # eef_step
            0.0  # jump_threshold
        )
        eef_step += 0.05

    return plan_cart, plan_joint, fraction


def set_ur5e_controller_io(state: int = 0) -> None:
    """Set io values on UR5e controller.
    pose
            state (int, optional): State to set pin to. Defaults to 0 (digital off/ low voltage).
    """
    rospy.wait_for_service("/ur_hardware_interface/set_io")
    try:
        IOService = rospy.ServiceProxy("/ur_hardware_interface/set_io", SetIO)
        IOService(1, 4, state)
    except rospy.ServiceException as e:
        print("Service unavailable: %s" % e)


def move_to_next_joint_values(joints: list = []) -> None:
    """
        move to the next joint values, than set pin to 1 (digital on/ high voltage) to meassure the pose.
        Finally set pin to 0 (digital off/ low voltage) again.
    Args:
        joints (list): List of joint values. Defaults to [].
    """
    arm.set_start_state_to_current_state()
    arm.go(joints, wait=True)
    sleep(3)
    # set pin to 1
    set_ur5e_controller_io(state=HIGH_VOLTAGE)
    sleep(3)
    # set pint to 0
    set_ur5e_controller_io(state=LOW_VOLTAGE)


def save_joints(
        joint_values: list, file_name: csv = pathlib.Path.cwd() / "joint_values.csv"
):
    """save joint values in a csv file

    Args:
        joint_values (list): list of joint values
        file_name (csv, optional):the file csv where the joints values are goint to be saved.
        Defaults to "joint_values.csv".
    """

    with open(file_name, "w", encoding="UTF8", newline="") as f:
        writer = csv.writer(f)
        # header
        row = ["", "q0", "q1", "q2", "q3", "q4", "q5"]
        writer.writerow(row)
        for joints in joint_values:
            writer.writerow(joints)
    print("Result joint values file successfully created. ")


def save_robot_pose(
        pose_values: list, file_name: csv = pathlib.Path.cwd() / "robot_pose_values.csv"
):
    """Save poses in a csv file

    Args:
        pose_values (list): list with the position and orientation of the poses given to the robot
        file_name (csv, optional): path where the pose values are going to be saved.
         Defaults to pathlib.Path.cwd()/"robot_pose_values.csv".
    """

    with open(file_name, "w", encoding="UTF8", newline="") as f:
        writer = csv.writer(f)
        row = ["", "x", "y", "z", "rx", "ry", "rz"]
        writer.writerow(row)
        for pose in pose_values:
            writer.writerow(pose)
    print("Result robot pose values file successfully created. ")


def save_LT_pose(
        pose_values: list, file_name: csv = pathlib.Path.cwd() / "LT_pose.csv"
):
    """save position meassured with the Laser Tracker(LT) in a csv file

    Args:
        pose_values (list): list of the position(x,y,z)of poses meassured from laser tracker
        file_name (csv, optional): file path where the pose values are going to be saved.
        Defaults to pathlib.Path.cwd()/"LT_pose.csv".
    """

    with open(file_name, "w", encoding="UTF8", newline="") as f:
        writer = csv.writer(f)

        for pose in pose_values:
            writer.writerow(pose)
    print("Result LT pose values file successfully created. ")


def process_xyz(
        y_raw: csv = pathlib.Path.cwd() / "LT_pose.csv",
        file_name: csv = pathlib.Path.cwd() / "LT_poses_processed.csv",
) -> None:
    """transform the raw data in the format X, Y, Z
                                            x1,y1,z1
                                            ...
        and save it into csv file

    Args:
        y_raw (csv, optional): _description_. Defaults to pathlib.Path.cwd()/"LT_pose.csv".
        file_name (csv, optional): _description_. Defaults to pathlib.Path.cwd()/"LT_poses_processed.csv".
    """
    rows = []
    # eliminating what is not position X,Y,Z
    with open(y_raw, "r", encoding="UTF8", newline="") as f:
        for line in f:
            row = (
                line.replace("b'X,", "")
                .replace("Y,", "")
                .replace("Z,", "")
                .replace("Time(sec),", "")
                .split(",")
            )
            rows.append(row[0:3])

    # Write the rows in file
    with open(file_name, "w", encoding="UTF8", newline="") as f:
        writer = csv.writer(f)
        row = ["", "x", "y", "z"]
        writer.writerow(row)
        for pose in rows:
            # convert values into meters
            pos = list(np.float_(pose) * 1e-3)
            writer.writerow((pos))


if __name__ == "__main__":

    UDP_IP = "255.255.255.255"
    UDP_PORT = 10000

    # Connect Laser tracker via UDP
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # Internet  # UDP
    sock.bind((UDP_IP, UDP_PORT))
    poses = []
    # Initiate a node in ros
    rospy.init_node("forward_kinematics", anonymous=True)
    moveit_commander.roscpp_initialize(sys.argv)
    robot_moveit = moveit_commander.RobotCommander()
    arm = MoveGroupCommander("manipulator")
    arm.set_max_velocity_scaling_factor(0.1)

    rospy.loginfo("Forward Kinematics node has been started.")

    for it in range(1):

        success = 0
        resp = true
        while success < 1 and resp:

            # sample random pose
            waypoints = get_random_waypoints_new()
            arm.go(waypoints[0], wait=True)
            arm.stop()
            start_joint = arm.get_current_joint_values()
            plan_cart, plan_joint, success = get_plan(arm, waypoints)

            if success == 1:

                rospy.loginfo("---------Executing planing------")
                resp = arm.execute(plan_cart, wait=True)

                if resp:
                    rospy.loginfo("---------Executing ist succesful------")
                    final_joint = arm.get_current_joint_values()
                    rospy.loginfo("---------Printing actual pose------")
                    c_pose = arm.get_current_pose().pose
                    print(c_pose.position)
                    poses.append([c_pose.position.x, c_pose.position.y, c_pose.position.z])

                    rospy.loginfo("--------saving data from LT------- ")

                    try:
                        data, addr = sock.recvfrom(512)
                        data_pos = str(data).split(",")
                        rospy.loginfo("--------printing data from LT-------")
                        print(data_pos)

                    except:
                        rospy.loginfo("Connection with LT failed. Try again.")

                    # saving positions of poses from robot and LT into arrays
                    robot_xyz = waypoints[-1]
                    LT_xyz = np.array([data_pos[1], data_pos[3], data_pos[5]], dtype=float)
                    # convert values into meters
                    LT_xyz = LT_xyz * 1e-3

                    # sanity check with euclidian norm (<= 10mm)
                    if norm(LT_xyz - robot_xyz) <= 10 * 1e-3:
                        # data_pos_LT.append(data_pos)
                        pose_values.append(robot_xyz)
                        # convert to degrees
                        joint_values.append(np.float_(final_joint) * (180 / pi))
                    else:
                        resp = False
                        rospy.loginfo(
                            "Distance between LT pose and robot pose is large!!. Point will not be saved"
                        )

    save_LT_pose(data_pos)
    save_joints(joint_values)
    save_robot_pose(pose_values)
    # save_robot_pose(poses,"poses_final.csv")

    process_xyz()