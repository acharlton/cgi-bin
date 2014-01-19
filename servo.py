#!/usr/bin/python

from Adafruit_PWM_Servo_Driver import PWM
import time
import cgi
form = cgi.FieldStorage()
move = form.getvalue('move')
pan = form.getvalue('pan',240)
tilt = form.getvalue('tilt',240)

print "Content-type:text/html"
print "Access-Control-Allow-Origin: *"
print

pwm = PWM(0x40, debug=False)

def setServoPulse(channel, pulse):
  pulseLength = 1000000                   # 1,000,000 us per second
  pulseLength /= 60                       # 60 Hz
  print "%d us per period" % pulseLength
  pulseLength /= 4096                     # 12 bits of resolution
  print "%d us per bit" % pulseLength
  pulse *= 1000
  pulse /= pulseLength
  pwm.setPWM(channel, 0, pulse)

pwm.setPWMFreq(60)                        # Set frequency to 60 Hz

if tilt == 'undefined':
	with open('lastposition', 'rw+') as f:
		data = f.read()
		words = data.split(":")
        	tilt = words[0]
        	pan = words[1]

tiltAngle = int(tilt)
panAngle = int(pan)

if move == "up":
	tiltAngle = tiltAngle + 20
	if tiltAngle > 360:
		tiltAngle = 360	
	pwm.setPWM(1,0,tiltAngle)
if move == "down":
	tiltAngle = tiltAngle - 20
	if tiltAngle < 220:
		tiltAngle = 220	
	pwm.setPWM(1,0,tiltAngle)
if move=="right":
	panAngle = panAngle - 20
	if panAngle < 170:
		panAngle = 170
	pwm.setPWM(0,0,panAngle)
if move=="left":
	panAngle = panAngle + 20
	if panAngle > 420:
		panAngle = 420
	pwm.setPWM(0,0,panAngle)

f = open('lastposition','rw+')
f.write(str(tiltAngle)+":")
f.write(str(panAngle))
f.close()

print panAngle,tiltAngle

