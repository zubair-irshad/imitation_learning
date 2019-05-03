#!/usr/bin/env python
import rospy
import numpy as np
from geometry_msgs.msg import Point, Twist
from nav_msgs.msg import Odometry
from sensor_msgs.msg import JointState
import math
from edumip_msgs.msg import EduMipState

from geometry_msgs.msg import TransformStamped

class process(object):
	def __init__(self):

		self.publisher = rospy.Publisher("joint_states", JointState, queue_size=10)
		self.subscriber_odom = rospy.Subscriber("/edumip/state", EduMipState, self.EduMipState_Callback)

		joint_state = JointState()

		print("Hellllllllllllllllllllllllllllllllo")
			#????????????????????????????????????????????? CHANGE 0.034 ??????????????????????????

	def EduMipState_Callback(self, data):

		print("Hello")

		br = tf2_ros.TransformBroadcaster()
		t = TransformStamped()
		t.header.stamp = rospy.Time.now()
		t.header.frame_id = "world"
		t.child_frame_id  = "3dof_body"

		t.transform.translation.x = data.body_frame_easting
		t.transform.translation.y = data.body_frame_northing
		t.transform.translation.z = 0.034
		q = tf_conversions.transformations.quaternion_from_euler(0, 0, data.theta,math.pi/2 - data.heading)
		t.transform.rotation.x = q[0]
		t.transform.rotation.y = q[1]
		t.transform.rotation.z = q[2]
		t.transform.rotation.w = q[3]

		br.sendTransform(t)



		# br = tf.TransformBroadcaster()
		# br.sendTransform((data.body_frame_easting, data.body_frame_northing, 0.034), tf.transformations.quaternion_from_euler(0, 0, data.theta,math.pi/2 - data.heading), rospy.Time.now(),"3dof_body","world")

		joint_state.header.stamp = rospy.Time.now();

		joint_state.name = ['wheel_angle_L', 'wheel_angle_R']
		joint_state.position[0]  = ['data.wheel_angle_L','data.wheel_angle_R']
		publisher.publish(joint_state)

				


def main():
	rospy.init_node('ks_publisher', anonymous=True)
	process()
	try:
		rospy.spin()
	except KeyboardInterrupt:
		print("Shutting down ROS")

if __name__ == '__main__':
	try:
		main()
	except rospy.ROSInterruptException:
		pass
