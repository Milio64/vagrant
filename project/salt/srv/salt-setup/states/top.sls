#STATES TOP FILE van salt-setup
base:
  '*':
    - minion-grain
    - gitrepo
    - salt-config

