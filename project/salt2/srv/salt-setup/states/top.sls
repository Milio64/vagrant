#STATES TOP FILE van salt-setup
base:
  '*':
    - minion-grain
  'salt-*':
    - gitrepo
    - salt-config

