import os
import paramiko
import re
import sys
import time

def ssh_connection_to_pdu(host, username, password):
  port = 22
  ssh = paramiko.SSHClient()
  ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
  ssh.connect(host, port, username, password, look_for_keys=False, allow_agent=False)
  return ssh

def rcp_to_command(rcp):
  m = re.match("RCP-(.?)-([0-9]+)", rcp)
  if m:
    name = m.group(1)
    num = int(m.group(2))
    return 'power 1.%s.%d' % (name, num)
  else:
    raise Exception("Cannot parse RCP name")

def usage(argv):
  print("%s <USERNAME> <PASSWORD> <HOSTNAME> <experiment_duration>" % argv[0])
  sys.exit()

def main(argv):
  if len(argv) < 5:
    usage(argv)

  username = argv[1]
  password = argv[2]
  hostname = argv[3]
  experiment_duration = int(argv[4])
  start_time = round(time.time())
  end_time = start_time + experiment_duration

  pdu1 = ssh_connection_to_pdu("r4spdu1.in.cs.ucy.ac.cy", username, password)
  pdu2 = ssh_connection_to_pdu("r4spdu2.in.cs.ucy.ac.cy", username, password)

  host_to_rcps = {}
  host_to_rcps['shasta'] = [(pdu2, 'RCP-A-2')]
  host_to_rcps['tahoe'] = [(pdu1, 'RCP-A-2'), (pdu2, 'RCP-A-3')]

  rcps = host_to_rcps[hostname]
  while round(time.time()) < end_time:
    power = 0
    for rcp in rcps:
      pdu_ssh = rcp[0]
      pdu_command = rcp_to_command(rcp[1])
      stdin, stdout, stderr = pdu_ssh.exec_command(pdu_command)
      lines = stdout.readlines()
      m = re.match("\[.*\]-+\(\d*\).([0-9]+.?[0-9]*).W", lines[5])
      if m:
        power += float(m.group(1))
    print(str(round(time.time() - start_time))+","+str(power))

if __name__ == "__main__":
  main(sys.argv)