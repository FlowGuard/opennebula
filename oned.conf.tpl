#*******************************************************************************
#                       OpenNebula Configuration file
#*******************************************************************************

#*******************************************************************************
# Daemon configuration attributes
#-------------------------------------------------------------------------------
#  MANAGER_TIMER: Time in seconds the core uses to evaluate periodical functions.
#  MONITORING_INTERVALS cannot have a smaller value than MANAGER_TIMER.
#
#  MONITORING_INTERVAL_MARKET: Time in seconds between market monitorization.
#  MONITORING_INTERVAL_DATASTORE: Time in seconds between image monitorization.
#  MONITORING_INTERVAL_DB_UPDATE: Time in seconds between DB writes of VM
#  monitoring information. -1 to disable DB updating and 0 to write every update
#
#  DS_MONITOR_VM_DISK: Number of MONIROTING_INTERVAL_DATASTORE intervals to monitor
#  VM disks. 0 to disable. Only applies to fs and fs_lvm datastores
#
#  SCRIPTS_REMOTE_DIR: Remote path to store the monitoring and VM management
#  scripts.
#
#  DB: Configuration attributes for the database backend
#   backend : can be sqlite or mysql (default is sqlite)
#   server  : (mysql) host name or an IP address for the MySQL server
#   port    : (mysql) port for the connection to the server.
#                     If set to 0, the default port is used.
#   user    : (mysql) user's MySQL login ID
#   passwd  : (mysql) the password for user
#   db_name : (mysql) the database name
#   connections: (mysql) number of max. connections to mysql server
#   compare_binary: (mysql) compare strings using BINARY clause
#                   makes name searches case sensitive.
#   encoding: charset to use for the db connections
#   timeout : (sqlite) timeout in ms for acquiring lock to DB,
#             should be at least 100 ms
#   errors_limit : number of consecutive DB errors to stop oned node in HA
#                  default 25, use -1 to disable this feature
#
#  VNC_PORTS: VNC port pool for automatic VNC port assignment, if possible the
#  port will be set to ``START`` + ``VMID``
#   start   : first port to assign
#   reserved: comma separated list of ports or ranges. Two numbers separated by
#   a colon indicate a range.
#
#  LOG: Configuration for the logging system
#   system: defines the logging system:
#      file      to log in the oned.log file
#      syslog    to use the syslog facilities
#      std       to use the default log stream (stderr) to use with systemd
#   debug_level: 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG
#
#*******************************************************************************

LOG = [
  SYSTEM      = "file",
  DEBUG_LEVEL = 3
]

#MANAGER_TIMER = 15

MONITORING_INTERVAL_DATASTORE = 300
MONITORING_INTERVAL_MARKET    = 600
MONITORING_INTERVAL_DB_UPDATE = 0

#DS_MONITOR_VM_DISK = 10

SCRIPTS_REMOTE_DIR=/var/tmp/one

# DB = [ BACKEND = "sqlite",
#        TIMEOUT = 2500 ]

DB = [ BACKEND = "mysql",
       SERVER  = "{{ MYSQL_HOST }}",
       PORT    = {{ MYSQL_PORT|default(3306) }},
       USER    = "{{ MYSQL_USER }}",
       PASSWD  = "{{ MYSQL_PASSWORD }}",
       DB_NAME = "{{ MYSQL_DATABASE }}"
       CONNECTIONS = 25,
       COMPARE_BINARY = "no" ]

VNC_PORTS = [
    START    = 5900,
    RESERVED = "32768:65536"
    # RESERVED = "6800, 6801, 6810:6820, 9869"
]

#*******************************************************************************
# Server network and connection
#-------------------------------------------------------------------------------
#  PORT: Port where oned will listen for xmlrpc calls.
#
#  LISTEN_ADDRESS: Host IP to listen on for xmlrpc calls (default: all IPs).
#
#  HOSTNAME: This Hostname is used by OpenNebula daemon to connect to the
#  frontend during drivers operations. If this variable is not set, OpenNebula
#  will auto detect it. It can be in FQDN format, hostname or an IP

PORT = 2633

LISTEN_ADDRESS = "0.0.0.0"

# HOSTNAME = "one-hostname"

#*******************************************************************************
# API configuration attributes
#-------------------------------------------------------------------------------
#  VM_SUBMIT_ON_HOLD: Forces VMs to be created on hold state instead of pending.
#  Values: YES or NO.
#  API_LIST_ORDER: Sets order (by ID) of elements in list API calls.
#  Values: ASC (ascending order) or DESC (descending order)
#*******************************************************************************
#
#API_LIST_ORDER = "DESC"
#VM_SUBMIT_ON_HOLD = "NO"

#*******************************************************************************
# Federation & HA configuration attributes
#-------------------------------------------------------------------------------
# Control the federation capabilities of oned. Operation in a federated setup
# requires a special DB configuration.
#
#  FEDERATION: Federation attributes
#   MODE: Operation mode of this oned.
#       STANDALONE no federated.This is the default operational mode
#       MASTER     this oned is the master zone of the federation
#       SLAVE      this oned is a slave zone
#   ZONE_ID: The zone ID as returned by onezone command
#   SERVER_ID: ID identifying this server in the zone as returned by the
#   onezone server-add command. This ID controls the HA configuration of
#   OpenNebula:
#     -1 (default) OpenNebula will operate in "solo" mode no HA
#     <id> Operate in HA (leader election and state replication)
#   MASTER_ONED: The xml-rpc endpoint of the master oned, e.g.
#   http://master.one.org:2633/RPC2
#
#
#   RAFT: Algorithm attributes
#     LIMIT_PURGE: Number of logs that will be deleted on each purge.
#     LOG_RETENTION: Number of DB log records kept, it determines the
#     synchronization window across servers and extra storage space needed.
#     LOG_PURGE_TIMEOUT: How often applied records are purged according the log
#     retention value. (in seconds)
#     ELECTION_TIMEOUT_MS: Timeout to start a election process if no heartbeat
#     or log is received from leader.
#     BROADCAST_TIMEOUT_MS: How often heartbeats are sent to  followers.
#     XMLRPC_TIMEOUT_MS: To timeout raft related API calls. To set an infinite
#     timeout set this value to 0.
#
#   RAFT_LEADER_HOOK: Executed when a server transits from follower->leader
#     The purpose of this hook is to configure the Virtual IP.
#     COMMAND: raft/vip.sh is a fully working script, this should not be changed
#     ARGUMENTS: <interface> and <ip_cidr> must be replaced. For example
#                ARGUMENTS = "leader ens1 10.0.0.2/24"
#
#   RAFT_FOLLOWER_HOOK: Executed when a server transits from leader->follower
#     The purpose of this hook is to configure the Virtual IP.
#     COMMAND: raft/vip.sh is a fully working script, this should not be changed
#     ARGUMENTS: <interface> and <ip_cidr> must be replaced. For example
#                ARGUMENTS = "follower ens1 10.0.0.2/24"
#
#  NOTE: Timeout tunning depends on the latency of the servers (network and load)
#  as well as the max downtime tolerated by the system. Timeouts needs to be
#  greater than 10ms
#
#*******************************************************************************

FEDERATION = [
    MODE          = "STANDALONE",
    ZONE_ID       = 0,
    SERVER_ID     = -1,
    MASTER_ONED   = ""
]

RAFT = [
    LIMIT_PURGE          = 100000,
    LOG_RETENTION        = 500000,
    LOG_PURGE_TIMEOUT    = 600,
    ELECTION_TIMEOUT_MS  = 2500,
    BROADCAST_TIMEOUT_MS = 500,
    XMLRPC_TIMEOUT_MS    = 450
]

# Executed when a server transits from follower->leader
# RAFT_LEADER_HOOK = [
#     COMMAND = "raft/vip.sh",
#     ARGUMENTS = "leader interface ip_cidr [interface ip_cidr ...]"
# ]

# Executed when a server transits from leader->follower
# RAFT_FOLLOWER_HOOK = [
#     COMMAND = "raft/vip.sh",
#     ARGUMENTS = "follower interface ip_cidr [interface ip_cidr ...]"
# ]

#*******************************************************************************
# Default showback cost
#-------------------------------------------------------------------------------
# The following attributes define the default cost for Virtual Machines that
# don't have a CPU, MEMORY or DISK cost. This is used by the oneshowback
# calculate method.
#*******************************************************************************

DEFAULT_COST = [
    CPU_COST    = 0,
    MEMORY_COST = 0,
    DISK_COST   = 0
]

#*******************************************************************************
# XML-RPC server configuration
#-------------------------------------------------------------------------------
#  These are configuration parameters for oned's xmlrpc-c server
#
#  MAX_CONN: Maximum number of simultaneous TCP connections the server
#  will maintain
#
#  MAX_CONN_BACKLOG: Maximum number of TCP connections the operating system
#  will accept on the server's behalf without the server accepting them from
#  the operating system
#
#  KEEPALIVE_TIMEOUT: Maximum time in seconds that the server allows a
#  connection to be open between RPCs
#
#  KEEPALIVE_MAX_CONN: Maximum number of RPCs that the server will execute on
#  a single connection
#
#  TIMEOUT: Maximum time in seconds the server will wait for the client to
#  do anything while processing an RPC. This timeout will be also used when
#  proxy calls to the master in a federation.
#
#  RPC_LOG: Create a separated log file for xml-rpc requests, in
#  "/var/log/one/one_xmlrpc.log".
#
#  MESSAGE_SIZE: Buffer size in bytes for XML-RPC responses.
#
#  LOG_CALL_FORMAT: Format string to log XML-RPC calls. Interpreted strings:
#     %i -- request id
#     %m -- method name
#     %u -- user id
#     %U -- user name
#     %l[number] -- param list and number of characters (optional) to print
#                   each parameter, default is 20. Example: %l300
#     %p -- user password
#     %g -- group id
#     %G -- group name
#     %a -- auth token
#     %A -- client IP address (only IPv4 supported)
#     %P -- client TCP port
#     %% -- %
#*******************************************************************************

#MAX_CONN           = 15
#MAX_CONN_BACKLOG   = 15
#KEEPALIVE_TIMEOUT  = 15
#KEEPALIVE_MAX_CONN = 30
#TIMEOUT            = 15
#RPC_LOG            = NO
#MESSAGE_SIZE       = 1073741824
#LOG_CALL_FORMAT    = "Req:%i UID:%u IP:%A %m invoked %l20"

#*******************************************************************************
# Physical Networks configuration
#*******************************************************************************
#  NETWORK_SIZE: Here you can define the default size for the virtual networks
#
#  MAC_PREFIX: Default MAC prefix to be used to create the auto-generated MAC
#  addresses is defined here (this can be overwritten by the Virtual Network
#  template)
#
#  VLAN_IDS: VLAN ID pool for the automatic VLAN_ID assignment. This pool
#  is for 802.1Q networks (Open vSwitch and 802.1Q drivers). The driver
#  will try first to allocate VLAN_IDS[START] + VNET_ID
#     start: First VLAN_ID to use
#     reserved: Comma separated list of VLAN_IDs or ranges. Two numbers
#     separated by a colon indicate a range.
#
# VXLAN_IDS: Automatic VXLAN Network ID (VNI) assignment. This is used
# for vxlan networks.
#     start: First VNI to use
#     NOTE: reserved is not supported by this pool
#
# PCI_PASSTHROUGH_BUS: Default bus to attach passthrough devices in the guest,
# in hex notation. It may be overwritten in the PCI device using the BUS
# attribute.
#*******************************************************************************

NETWORK_SIZE = 254

MAC_PREFIX   = "02:00"

VLAN_IDS = [
    START    = "2",
    RESERVED = "0, 1, 4095"
]

VXLAN_IDS = [
    START = "2"
]

#PCI_PASSTHROUGH_BUS = "0x01"

#*******************************************************************************
# DataStore Configuration
#*******************************************************************************
#  DATASTORE_LOCATION: Path for Datastores. It IS the same for all the hosts
#  and front-end. It defaults to /var/lib/one/datastores (in self-contained mode
#  defaults to $ONE_LOCATION/var/datastores). Each datastore has its own
#  directory (called BASE_PATH) in the form: $DATASTORE_LOCATION/<datastore_id>
#  You can symlink this directory to any other path if needed. BASE_PATH is
#  generated from this attribute each time oned is started.
#
#  DATASTORE_CAPACITY_CHECK: Checks that there is enough capacity before
#  creating a new image. Defaults to Yes
#
#  DEFAULT_IMAGE_TYPE: This can take values
#       OS        Image file holding an operating system
#       CDROM     Image file holding a CDROM
#       DATABLOCK Image file holding a datablock, created as an empty block
#
#  DEFAULT_DEVICE_PREFIX: This can be set to
#       hd        IDE prefix
#       sd        SCSI
#       vd        KVM virtual disk
#
#  DEFAULT_CDROM_DEVICE_PREFIX: Same as above but for CDROM devices.
#
#  DEFAULT_IMAGE_PERSISTENT: Control the default value for the PERSISTENT
#  attribute on image creation (oneimage clone, onevm disk-saveas). If blank
#  images will inherit the persistent attribute from the base image.
#
#  DEFAULT_IMAGE_PERSISTENT_NEW: Control the default value for the PERSISTENT
#  attribute on image creation (oneimage create). By default images are no
#  persistent if not set.
#*******************************************************************************

#DATASTORE_LOCATION  = /var/lib/one/datastores

DATASTORE_CAPACITY_CHECK = "yes"

DEFAULT_DEVICE_PREFIX       = "sd"
DEFAULT_CDROM_DEVICE_PREFIX = "hd"

DEFAULT_IMAGE_TYPE           = "OS"
#DEFAULT_IMAGE_PERSISTENT     = ""
#DEFAULT_IMAGE_PERSISTENT_NEW = ""

#*******************************************************************************
# Monitor Daemon
#*******************************************************************************
#  Monitor daemon, specific monitor drivers can be added in the monitord
#  configuration file (monitord.conf)
#
#   name       : OpenNebula name for the daemon
#
#   executable : path of the information driver executable, can be an
#                absolute path or relative to $ONE_LOCATION/lib/mads (or
#                /usr/lib/one/mads/ if OpenNebula was installed in /)
#
#   arguments  : for the monitor daemon
#     -c : configuration file (monitord.conf by default)
#
#   threads    : number of threads used to process messages from monitor daemon
#*******************************************************************************
IM_MAD = [
      NAME       = "monitord",
      EXECUTABLE = "onemonitord",
      ARGUMENTS  = "-c monitord.conf",
      THREADS    = 8 ]

#*******************************************************************************
# Virtualization Driver Configuration
#*******************************************************************************
# You can add more virtualization managers with different configurations but
# make sure it has different names.
#
#   name      : name of the virtual machine manager driver
#
#   executable: path of the virtualization driver executable, can be an
#               absolute path or relative to $ONE_LOCATION/lib/mads (or
#               /usr/lib/one/mads/ if OpenNebula was installed in /)
#
#   arguments : for the driver executable
#
#   default   : default values and configuration parameters for the driver, can
#               be an absolute path or relative to $ONE_LOCATION/etc (or
#               /etc/one/ if OpenNebula was installed in /)
#
#   type      : driver type, supported drivers: xen, kvm, xml
#
#   keep_snapshots: do not remove snapshots on power on/off cycles and live
#   migrations if the hypervisor supports that.
#
#   live_resize: [yes|no] Hypervisor supports hotplug VCPU and memory
#
#   support_shareable: [yes|no] Hypervisor supports shareable disks
#
#   imported_vms_actions : comma-separated list of actions supported
#                          for imported vms. The available actions are:
#                              migrate
#                              live-migrate
#                              terminate
#                              terminate-hard
#                              undeploy
#                              undeploy-hard
#                              hold
#                              release
#                              stop
#                              suspend
#                              resume
#                              delete
#                              delete-recreate
#                              reboot
#                              reboot-hard
#                              resched
#                              unresched
#                              poweroff
#                              poweroff-hard
#                              disk-attach
#                              disk-detach
#                              nic-attach
#                              nic-detach
#                              snap-create
#                              snap-delete
#*******************************************************************************

#-------------------------------------------------------------------------------
#  KVM Virtualization Driver Manager Configuration
#    -r number of retries when monitoring a host
#    -t number of threads, i.e. number of hosts monitored at the same time
#    -l <actions[=command_name]> actions executed locally, command can be
#        overridden for each action.
#        Valid actions: deploy, shutdown, cancel, save, restore, migrate, poll
#        An example: "-l migrate=migrate_local,save"
#    -d <actions> comma separated list of actions which forward SSH agent
#        from frontend to remote host (default migrate)
#    -p more than one action per host in parallel, needs support from hypervisor
#    -s <shell> to execute remote commands, bash by default
#    -w Timeout in seconds to execute external commands (default unlimited)
#
#  Note: You can use type = "qemu" to use qemu emulated guests, e.g. if your
#  CPU does not have virtualization extensions or use nested Qemu-KVM hosts
#-------------------------------------------------------------------------------
VM_MAD = [
    NAME           = "kvm",
    SUNSTONE_NAME  = "KVM",
    EXECUTABLE     = "one_vmm_exec",
    ARGUMENTS      = "-t 15 -r 0 kvm",
    DEFAULT        = "vmm_exec/vmm_exec_kvm.conf",
    TYPE           = "kvm",
    KEEP_SNAPSHOTS = "yes",
    LIVE_RESIZE    = "yes",
    SUPPORT_SHAREABLE    = "yes",
    IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
        resume, delete, reboot, reboot-hard, resched, unresched, disk-attach,
        disk-detach, nic-attach, nic-detach, snapshot-create, snapshot-delete"
]

# This variant should be used for nested virtualization
VM_MAD = [
    NAME           = "qemu",
    SUNSTONE_NAME  = "QEMU",
    EXECUTABLE     = "one_vmm_exec",
    ARGUMENTS      = "-t 15 -r 0 kvm",
    DEFAULT        = "vmm_exec/vmm_exec_kvm.conf",
    TYPE           = "qemu",
    KEEP_SNAPSHOTS = "yes",
    LIVE_RESIZE    = "yes",
    SUPPORT_SHAREABLE    = "yes",
    IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
        resume, delete, reboot, reboot-hard, resched, unresched, disk-attach,
        disk-detach, nic-attach, nic-detach, snapshot-create, snapshot-delete"
]
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  LXD Virtualization Driver Manager Configuration
#    -r number of retries when monitoring a host
#    -t number of threads, i.e. number of hosts monitored at the same time
#    -l <actions[=command_name]> actions executed locally, command can be
#        overridden for each action.
#        Valid actions: deploy, shutdown, cancel, save, restore, migrate, poll
#        An example: "-l migrate=migrate_local,save"
#    -d <actions> comma separated list of actions which forward SSH agent
#        from frontend to remote host (default migrate)
#    -p more than one action per host in parallel, needs support from hypervisor
#    -s <shell> to execute remote commands, bash by default
#    -w Timeout in seconds to execute external commands (default unlimited)
#
#-------------------------------------------------------------------------------
VM_MAD = [
    NAME           = "lxd",
    SUNSTONE_NAME  = "LXD",
    EXECUTABLE     = "one_vmm_exec",
    ARGUMENTS      = "-t 15 -r 0 lxd",
    # DEFAULT        = "vmm_exec/vmm_exec_lxd.conf",
    TYPE           = "xml",
    KEEP_SNAPSHOTS = "no",
    IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, reboot, reboot-hard, poweroff, poweroff-hard, suspend, resume, stop, delete,  nic-attach, nic-detach"
]

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  LXC Virtualization Driver Manager Configuration
#    -r number of retries when monitoring a host
#    -t number of threads, i.e. number of hosts monitored at the same time
#    -l <actions[=command_name]> actions executed locally, command can be
#        overridden for each action.
#        Valid actions: deploy, shutdown, cancel, save, restore, migrate, poll
#        An example: "-l migrate=migrate_local,save"
#    -d <actions> comma separated list of actions which forward SSH agent
#        from frontend to remote host (default migrate)
#    -p more than one action per host in parallel, needs support from hypervisor
#    -s <shell> to execute remote commands, bash by default
#    -w Timeout in seconds to execute external commands (default unlimited)
#
#-------------------------------------------------------------------------------
VM_MAD = [
    NAME           = "lxc",
    SUNSTONE_NAME  = "LXC",
    EXECUTABLE     = "one_vmm_exec",
    ARGUMENTS      = "-t 15 -r 0 lxc",
    # DEFAULT        = "vmm_exec/vmm_exec_lxc.conf",
    TYPE           = "xml",
    KEEP_SNAPSHOTS = "no",
    IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, reboot, reboot-hard, poweroff, poweroff-hard, suspend, resume, stop, delete,  nic-attach, nic-detach"
]

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  Firecracker Virtualization Driver Manager Configuration
#    -r number of retries when monitoring a host
#    -t number of threads, i.e. number of hosts monitored at the same time
#    -l <actions[=command_name]> actions executed locally, command can be
#        overridden for each action.
#        Valid actions: deploy, shutdown, cancel, save, restore, migrate, poll
#        An example: "-l migrate=migrate_local,save"
#    -d <actions> comma separated list of actions which forward SSH agent
#        from frontend to remote host (default migrate)
#    -p more than one action per host in parallel, needs support from hypervisor
#    -s <shell> to execute remote commands, bash by default
#    -w Timeout in seconds to execute external commands (default unlimited)
#-------------------------------------------------------------------------------
VM_MAD = [
    NAME           = "firecracker",
    SUNSTONE_NAME  = "Firecracker",
    EXECUTABLE     = "one_vmm_exec",
    ARGUMENTS      = "-t 15 -r 0 firecracker",
    TYPE           = "xml",
    KEEP_SNAPSHOTS = "no"
]

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  vCenter Virtualization Driver Manager Configuration
#    -r number of retries when monitoring a host
#    -t number of threads, i.e. number of hosts monitored at the same time
#    -p more than one action per host in parallel, needs support from hypervisor
#    -s <shell> to execute commands, bash by default
#    -w Timeout in seconds to execute external commands (default unlimited)
#-------------------------------------------------------------------------------
VM_MAD = [
    NAME              = "vcenter",
    SUNSTONE_NAME     = "VMWare vCenter",
    EXECUTABLE        = "one_vmm_sh",
    ARGUMENTS         = "-p -t 15 -r 0 -s sh vcenter",
    TYPE              = "xml",
    KEEP_SNAPSHOTS    = "yes",
    DS_LIVE_MIGRATION = "yes",
    COLD_NIC_ATTACH   = "yes",
    LIVE_RESIZE       = "yes",
    IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
        resume, delete, reboot, reboot-hard, resched, unresched, poweroff,
        poweroff-hard, disk-attach, disk-detach, nic-attach, nic-detach,
        snapshot-create, snapshot-delete, migrate, live-migrate"
]
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  Dummy Virtualization Driver Configuration
#-------------------------------------------------------------------------------
#VM_MAD = [ NAME="dummy", SUNSTONE_NAME="Testing", EXECUTABLE="one_vmm_dummy",
#  TYPE="xml" ]
#-------------------------------------------------------------------------------

#*******************************************************************************
# Transfer Manager Driver Configuration
#*******************************************************************************
# You can add more transfer managers with different configurations but make
# sure it has different names.
#   name      : name for this transfer driver
#
#   executable: path of the transfer driver executable, can be an
#               absolute path or relative to $ONE_LOCATION/lib/mads (or
#               /usr/lib/one/mads/ if OpenNebula was installed in /)
#   arguments :
#       -t: number of threads, i.e. number of transfers made at the same time
#       -d: list of transfer drivers separated by commas, if not defined all the
#           drivers available will be enabled
#       -w: Timeout in seconds to execute external commands (default unlimited)
#*******************************************************************************

TM_MAD = [
    EXECUTABLE = "one_tm",
    ARGUMENTS = "-t 15 -d dummy,lvm,shared,fs_lvm,qcow2,ssh,ceph,dev,vcenter,iscsi_libvirt"
]

#*******************************************************************************
# Datastore Driver Configuration
#*******************************************************************************
# Drivers to manage the datastores, specialized for the storage backend
#   executable: path of the transfer driver executable, can be an
#               absolute path or relative to $ONE_LOCATION/lib/mads (or
#               /usr/lib/one/mads/ if OpenNebula was installed in /)
#
#   arguments : for the driver executable
#       -t number of threads, i.e. number of repo operations at the same time
#       -d datastore mads separated by commas
#       -s system datastore tm drivers, used to monitor shared system ds.
#       -w Timeout in seconds to execute external commands (default unlimited)
#*******************************************************************************

DATASTORE_MAD = [
    EXECUTABLE = "one_datastore",
    ARGUMENTS  = "-t 15 -d dummy,fs,lvm,ceph,dev,iscsi_libvirt,vcenter -s shared,ssh,ceph,fs_lvm,qcow2,vcenter"
]

#*******************************************************************************
# Marketplace Driver Configuration
#*******************************************************************************
# Drivers to manage different marketplaces, specialized for the storage backend
#   executable: path of the transfer driver executable, can be an
#               absolute path or relative to $ONE_LOCATION/lib/mads (or
#               /usr/lib/one/mads/ if OpenNebula was installed in /)
#
#   arguments : for the driver executable
#       -t number of threads, i.e. number of repo operations at the same time
#       -m marketplace mads separated by commas
#       --proxy proxy address if required to access the internet
#       -w Timeout in seconds to execute external commands (default unlimited)
#*******************************************************************************

MARKET_MAD = [
    EXECUTABLE = "one_market",
    ARGUMENTS  = "-t 15 -m http,s3,one,linuxcontainers,turnkeylinux,dockerhub"
]

#*******************************************************************************
# IPAM Driver Configuration
#*******************************************************************************
# Drivers to manage different IPAMs
#   executable: path of the IPAM driver executable, can be an
#               absolute path or relative to $ONE_LOCATION/lib/mads (or
#               /usr/lib/one/mads/ if OpenNebula was installed in /)
#
#   arguments : for the driver executable
#       -t number of threads, i.e. number of operations at the same time
#       -i IPAM mads separated by commas
#*******************************************************************************

IPAM_MAD = [
    EXECUTABLE = "one_ipam",
    ARGUMENTS  = "-t 1 -i dummy,aws,packet"
]

#*******************************************************************************
# Hook Manager Configuration
#*******************************************************************************
# The Driver (HM_MAD)
# -----------------------------------------------
#
# Used to execute the Hooks:
#   executable: path of the hook driver executable, can be an
#               absolute path or relative to $ONE_LOCATION/lib/mads (or
#               /usr/lib/one/mads/ if OpenNebula was installed in /)
#
#   arguments : for the driver executable, can be an absolute path or relative
#               to $ONE_LOCATION/etc (or /etc/one/ if OpenNebula was installed
#               in /)
#

HM_MAD = [
    EXECUTABLE = "one_hm",
    ARGUMENTS = "-p 2101 -l 2102 -b 127.0.0.1"]

#*******************************************************************************
# Hook Log Configuration
#*******************************************************************************
#
# LOG_RETENTION: Number of execution records saved in the database for each hook.
#

HOOK_LOG_CONF = [
    LOG_RETENTION = 20 ]

#*******************************************************************************
# Auth Manager Configuration
#*******************************************************************************
# AUTH_MAD: The Driver that will be used to authenticate (authn) and
# authorize (authz) OpenNebula requests. If defined OpenNebula will use the
# built-in auth policies.
#
#   executable: path of the auth driver executable, can be an
#               absolute path or relative to $ONE_LOCATION/lib/mads (or
#               /usr/lib/one/mads/ if OpenNebula was installed in /)
#
#   authn     : list of authentication modules separated by commas, if not
#               defined all the modules available will be enabled
#   authz     : list of authentication modules separated by commas
#
# DEFAULT_AUTH: The default authentication driver to use when OpenNebula does
# not know the user and needs to authenticate it externally.  If you want to
# use "default" (not recommended, but supported for backwards compatibility
# reasons) make sure you create a symlink pointing to the actual authentication
# driver in /var/lib/one/remotes/auth, and add "default" to the 'auth'
# parameter in the 'AUTH_MAD' section.
#
# SESSION_EXPIRATION_TIME: Time in seconds to keep an authenticated token as
# valid. During this time, the driver is not used. Use 0 to disable session
# caching
#
# ENABLE_OTHER_PERMISSIONS: Whether or not users can set the permissions for
# 'other', so publishing or sharing resources with others. Users in the oneadmin
# group will still be able to change these permissions. Values: YES or NO.
#
# DEFAULT_UMASK: Similar to Unix umask, sets the default resources permissions.
# Its format must be 3 octal digits. For example a umask of 137 will set
# the new object's permissions to 640 "um- u-- ---"
#*******************************************************************************

AUTH_MAD = [
    EXECUTABLE = "one_auth_mad",
    AUTHN = "ssh,x509,ldap,server_cipher,server_x509"
]

#DEFAULT_AUTH = "default"

SESSION_EXPIRATION_TIME = 900

#ENABLE_OTHER_PERMISSIONS = "YES"

DEFAULT_UMASK = 177

#*******************************************************************************
# OneGate
#   ONEGATE_ENDPOINT: The URL for the onegate server (the Gate to OpenNebula for
#   VMs). The onegate server is started using a separate command. The endpoint
#   MUST be consistent with the values in onegate-server.conf
#*******************************************************************************

#ONEGATE_ENDPOINT = "http://frontend:5030"

#*******************************************************************************
# VM Operations Permissions
#******************************************************************************
# The following parameters define the operations associated to the ADMIN,
# MANAGE and USE permissions. Note that some VM operations require additional
# permissions on other objects. Also some operations refers to a class of
# actions:
#   - disk-snapshot, includes create, delete and revert actions
#   - disk-attach, includes attach and detach actions
#   - nic-attach, includes attach and detach actions
#   - snapshot, includes create, delete and revert actions
#   - resched, includes resched and unresched actions
#******************************************************************************

VM_ADMIN_OPERATIONS  = "migrate, delete, recover, retry, deploy, resched"

VM_MANAGE_OPERATIONS = "undeploy, hold, release, stop, suspend, resume, reboot,
    poweroff, disk-attach, nic-attach, disk-snapshot, terminate, disk-resize,
    snapshot, updateconf, rename, resize, update, disk-saveas"

VM_USE_OPERATIONS    = ""

#*******************************************************************************
# Default Permissions for VDC ACL rules
#*******************************************************************************
# Default ACL rules created when resource is added to a VDC. The following
# attributes configures the permissions granted to the VDC group for each
# resource types:
#   DEFAULT_VDC_HOST_ACL: permissions granted on hosts added to a VDC.
#   DEFAULT_VDC_NET_ACL: permissions granted on vnets added to a VDC.
#   DEFAULT_VDC_DATASTORE_ACL: permissions granted on datastores to a VDC.
#
#   DEFAULT_VDC_CLUSTER_HOST_ACL: permissions granted to cluster hosts when a
#   cluster is added to the VDC.
#   DEFAULT_VDC_CLUSTER_NET_ACL: permissions granted to cluster vnets when a
#   cluster is added to the VDC.
#   DEFAULT_VDC_CLUSTER_DATASTORE_ACL: permissions granted to cluster datastores
#   when a cluster is added to the VDC.
#
# When defining the permissions you can use "" or "-" to not add any rule to
# that specific resource. Also you can combine several permissions with "+",
# for exampl "MANAGE+USE". Valid permissions are USE, MANAGE or ADMIN.
#
# Example:
# DEFAULT_VDC_HOST_ACL      = "MANAGE"
# Adds @<gid> HOST/#<hid> MANAGE #<zid> when a host is added to the VDC,
# eg. onevdc addhost <vdc> <zid> <hid>
#
# DEFAULT_VDC_VNET_ACL       = "USE"
# Adds @<gid> NET/#<vnetid> USE #<zid> when a vnet is added to the VDC,
# eg. onevdc addvnet <vdc> <zid> <vnetid>
#
# DEFAULT_VDC_DATASTORE_ACL = "USE"
# Adds @<gid> DATASTORE/#<dsid> USE #<zid> when a vnet is added to the VDC,
# eg. onevdc adddatastore <vdc> <zid> <dsid>
#
# DEFAULT_VDC_CLUSTER_HOST_ACL      = "MANAGE"
# DEFAULT_VDC_CLUSTER_NET_ACL       = "USE"
# DEFAULT_VDC_CLUSTER_DATASTORE_ACL = "USE"
# Adds:
#   @<gid> HOST/%<cid> MANAGE #<zid>
#   @<gid> DATASTORE+NET/%<cid> USE #<zid>
# when a cluster is added to the VDC, e.g. onevdc addcluster <vdc> <zid> <cid>
#*******************************************************************************

DEFAULT_VDC_HOST_ACL      = "MANAGE"
DEFAULT_VDC_VNET_ACL      = "USE"
DEFAULT_VDC_DATASTORE_ACL = "USE"

DEFAULT_VDC_CLUSTER_HOST_ACL      = "MANAGE"
DEFAULT_VDC_CLUSTER_NET_ACL       = "USE"
DEFAULT_VDC_CLUSTER_DATASTORE_ACL = "USE"

#*******************************************************************************
# Restricted Attributes Configuration
#*******************************************************************************
# The following attributes are restricted to users outside the oneadmin group
#*******************************************************************************

VM_RESTRICTED_ATTR = "CONTEXT/FILES"
VM_RESTRICTED_ATTR = "NIC/MAC"
VM_RESTRICTED_ATTR = "NIC/VLAN_ID"
VM_RESTRICTED_ATTR = "NIC/BRIDGE"
VM_RESTRICTED_ATTR = "NIC/FILTER"
VM_RESTRICTED_ATTR = "NIC/FILTER_IP_SPOOFING"
VM_RESTRICTED_ATTR = "NIC/FILTER_MAC_SPOOFING"
VM_RESTRICTED_ATTR = "NIC/INBOUND_AVG_BW"
VM_RESTRICTED_ATTR = "NIC/INBOUND_PEAK_BW"
VM_RESTRICTED_ATTR = "NIC/INBOUND_PEAK_KB"
VM_RESTRICTED_ATTR = "NIC/OUTBOUND_AVG_BW"
VM_RESTRICTED_ATTR = "NIC/OUTBOUND_PEAK_BW"
VM_RESTRICTED_ATTR = "NIC/OUTBOUND_PEAK_KB"
VM_RESTRICTED_ATTR = "NIC/OPENNEBULA_MANAGED"
VM_RESTRICTED_ATTR = "NIC/VCENTER_INSTANCE_ID"
VM_RESTRICTED_ATTR = "NIC/VCENTER_NET_REF"
VM_RESTRICTED_ATTR = "NIC/VCENTER_PORTGROUP_TYPE"
VM_RESTRICTED_ATTR = "NIC/EXTERNAL"
VM_RESTRICTED_ATTR = "NIC_ALIAS/MAC"
VM_RESTRICTED_ATTR = "NIC_ALIAS/VLAN_ID"
VM_RESTRICTED_ATTR = "NIC_ALIAS/BRIDGE"
VM_RESTRICTED_ATTR = "NIC_ALIAS/INBOUND_AVG_BW"
VM_RESTRICTED_ATTR = "NIC_ALIAS/INBOUND_PEAK_BW"
VM_RESTRICTED_ATTR = "NIC_ALIAS/INBOUND_PEAK_KB"
VM_RESTRICTED_ATTR = "NIC_ALIAS/OUTBOUND_AVG_BW"
VM_RESTRICTED_ATTR = "NIC_ALIAS/OUTBOUND_PEAK_BW"
VM_RESTRICTED_ATTR = "NIC_ALIAS/OUTBOUND_PEAK_KB"
VM_RESTRICTED_ATTR = "NIC_ALIAS/OPENNEBULA_MANAGED"
VM_RESTRICTED_ATTR = "NIC_ALIAS/VCENTER_INSTANCE_ID"
VM_RESTRICTED_ATTR = "NIC_ALIAS/VCENTER_NET_REF"
VM_RESTRICTED_ATTR = "NIC_ALIAS/VCENTER_PORTGROUP_TYPE"
VM_RESTRICTED_ATTR = "NIC_ALIAS/EXTERNAL"
VM_RESTRICTED_ATTR = "NIC_DEFAULT/MAC"
VM_RESTRICTED_ATTR = "NIC_DEFAULT/VLAN_ID"
VM_RESTRICTED_ATTR = "NIC_DEFAULT/BRIDGE"
VM_RESTRICTED_ATTR = "NIC_DEFAULT/FILTER"
VM_RESTRICTED_ATTR = "NIC_DEFAULT/EXTERNAL"
VM_RESTRICTED_ATTR = "DISK/TOTAL_BYTES_SEC"
VM_RESTRICTED_ATTR = "DISK/TOTAL_BYTES_SEC_MAX_LENGTH"
VM_RESTRICTED_ATTR = "DISK/TOTAL_BYTES_SEC_MAX"
VM_RESTRICTED_ATTR = "DISK/READ_BYTES_SEC"
VM_RESTRICTED_ATTR = "DISK/READ_BYTES_SEC_MAX_LENGTH"
VM_RESTRICTED_ATTR = "DISK/READ_BYTES_SEC_MAX"
VM_RESTRICTED_ATTR = "DISK/WRITE_BYTES_SEC"
VM_RESTRICTED_ATTR = "DISK/WRITE_BYTES_SEC_MAX_LENGTH"
VM_RESTRICTED_ATTR = "DISK/WRITE_BYTES_SEC_MAX"
VM_RESTRICTED_ATTR = "DISK/TOTAL_IOPS_SEC"
VM_RESTRICTED_ATTR = "DISK/TOTAL_IOPS_SEC_MAX_LENGTH"
VM_RESTRICTED_ATTR = "DISK/TOTAL_IOPS_SEC_MAX"
VM_RESTRICTED_ATTR = "DISK/READ_IOPS_SEC"
VM_RESTRICTED_ATTR = "DISK/READ_IOPS_SEC_MAX_LENGTH"
VM_RESTRICTED_ATTR = "DISK/READ_IOPS_SEC_MAX"
VM_RESTRICTED_ATTR = "DISK/WRITE_IOPS_SEC"
VM_RESTRICTED_ATTR = "DISK/WRITE_IOPS_SEC_MAX_LENGTH"
VM_RESTRICTED_ATTR = "DISK/WRITE_IOPS_SEC_MAX"
VM_RESTRICTED_ATTR = "DISK/SIZE_IOPS_SEC"
VM_RESTRICTED_ATTR = "DISK/OPENNEBULA_MANAGED"
VM_RESTRICTED_ATTR = "DISK/VCENTER_DS_REF"
VM_RESTRICTED_ATTR = "DISK/VCENTER_INSTANCE_ID"
#VM_RESTRICTED_ATTR = "DISK/SIZE"
VM_RESTRICTED_ATTR = "DISK/ORIGINAL_SIZE"
VM_RESTRICTED_ATTR = "DISK/SIZE_PREV"
VM_RESTRICTED_ATTR = "DEPLOY_ID"
VM_RESTRICTED_ATTR = "CPU_COST"
VM_RESTRICTED_ATTR = "MEMORY_COST"
VM_RESTRICTED_ATTR = "DISK_COST"
VM_RESTRICTED_ATTR = "PCI"
VM_RESTRICTED_ATTR = "EMULATOR"
VM_RESTRICTED_ATTR = "RAW"
VM_RESTRICTED_ATTR = "USER_PRIORITY"
VM_RESTRICTED_ATTR = "USER_INPUTS/CPU"
VM_RESTRICTED_ATTR = "USER_INPUTS/MEMORY"
VM_RESTRICTED_ATTR = "USER_INPUTS/VCPU"
VM_RESTRICTED_ATTR = "VCENTER_VM_FOLDER"
VM_RESTRICTED_ATTR = "VCENTER_ESX_HOST"
VM_RESTRICTED_ATTR = "TOPOLOGY/PIN_POLICY"
VM_RESTRICTED_ATTR = "TOPOLOGY/HUGEPAGE_SIZE"

#VM_RESTRICTED_ATTR = "RANK"
#VM_RESTRICTED_ATTR = "SCHED_RANK"
#VM_RESTRICTED_ATTR = "REQUIREMENTS"
#VM_RESTRICTED_ATTR = "SCHED_REQUIREMENTS"

IMAGE_RESTRICTED_ATTR = "SOURCE"
IMAGE_RESTRICTED_ATTR = "VCENTER_IMPORTED"

#*******************************************************************************
# The following restricted attributes only apply to VNets that are a reservation.
# Normal VNets do not have restricted attributes.
#*******************************************************************************

VNET_RESTRICTED_ATTR = "VN_MAD"
VNET_RESTRICTED_ATTR = "PHYDEV"
VNET_RESTRICTED_ATTR = "VLAN_ID"
VNET_RESTRICTED_ATTR = "BRIDGE"
VNET_RESTRICTED_ATTR = "CONF"
VNET_RESTRICTED_ATTR = "BRIDGE_CONF"
VNET_RESTRICTED_ATTR = "OVS_BRIDGE_CONF"
VNET_RESTRICTED_ATTR = "IP_LINK_CONF"
VNET_RESTRICTED_ATTR = "FILTER"
VNET_RESTRICTED_ATTR = "FILTER_IP_SPOOFING"
VNET_RESTRICTED_ATTR = "FILTER_MAC_SPOOFING"

VNET_RESTRICTED_ATTR = "AR/VN_MAD"
VNET_RESTRICTED_ATTR = "AR/PHYDEV"
VNET_RESTRICTED_ATTR = "AR/VLAN_ID"
VNET_RESTRICTED_ATTR = "AR/BRIDGE"
VNET_RESTRICTED_ATTR = "AR/FILTER"
VNET_RESTRICTED_ATTR = "AR/FILTER_IP_SPOOFING"
VNET_RESTRICTED_ATTR = "AR/FILTER_MAC_SPOOFING"

VNET_RESTRICTED_ATTR = "CLUSTER_IDS"

VNET_RESTRICTED_ATTR = "EXTERNAL"

USER_RESTRICTED_ATTR = "VM_USE_OPERATIONS"
USER_RESTRICTED_ATTR = "VM_MANAGE_OPERATIONS"
USER_RESTRICTED_ATTR = "VM_ADMIN_OPERATIONS"

GROUP_RESTRICTED_ATTR = "VM_USE_OPERATIONS"
GROUP_RESTRICTED_ATTR = "VM_MANAGE_OPERATIONS"
GROUP_RESTRICTED_ATTR = "VM_ADMIN_OPERATIONS"

#*******************************************************************************
# Encrypted Attributes Configuration
#*******************************************************************************
# The following attributes are encrypted
#*******************************************************************************

HOST_ENCRYPTED_ATTR = "EC2_ACCESS"
HOST_ENCRYPTED_ATTR = "EC2_SECRET"
HOST_ENCRYPTED_ATTR = "AZ_SUB"
HOST_ENCRYPTED_ATTR = "AZ_CLIENT"
HOST_ENCRYPTED_ATTR = "AZ_SECRET"
HOST_ENCRYPTED_ATTR = "AZ_TENANT"
HOST_ENCRYPTED_ATTR = "VCENTER_PASSWORD"
HOST_ENCRYPTED_ATTR = "NSX_PASSWORD"
HOST_ENCRYPTED_ATTR = "ONE_PASSWORD"

# CLUSTER_ENCRYPTED_ATTR = "PROVISION/PACKET_TOKEN"

# DATASTORE_ENCRYPTED_ATTR = "PROVISION/PACKET_TOKEN"

# VM_ENCRYPTED_ATTR = "PACKET_TOKEN
# VM_ENCRYPTED_ATTR = "PROVISION/PACKET_TOKEN
VM_ENCRYPTED_ATTR = "CONTEXT/PASSWORD"

IMAGE_ENCRYPTED_ATTR = "LUKS_PASSWORD"

# VNET_ENCRYPTED_ATTR = "PROVISION/PACKET_TOKEN
# VNET_ENCRYPTED_ATTR = "PROVISION/PACKET_TOKEN
# VNET_ENCRYPTED_ATTR = "PROVISION/PACKET_TOKEN

# DDC encrypted attrs
DOCUMENT_ENCRYPTED_ATTR = "PROVISION_BODY"

#*******************************************************************************
# Inherited Attributes Configuration
#*******************************************************************************
# The following attributes will be copied from the resource template to the
# instantiated VMs. More than one attribute can be defined.
#
# INHERIT_IMAGE_ATTR: Attribute to be copied from the Image template
# to each VM/DISK.
#
# INHERIT_DATASTORE_ATTR: Attribute to be copied from the Datastore template
# to each VM/DISK.
#
# INHERIT_VNET_ATTR: Attribute to be copied from the Network template
# to each VM/NIC.
#*******************************************************************************

#INHERIT_IMAGE_ATTR     = "EXAMPLE"
#INHERIT_IMAGE_ATTR     = "SECOND_EXAMPLE"
#INHERIT_DATASTORE_ATTR = "COLOR"
#INHERIT_VNET_ATTR      = "BANDWIDTH_THROTTLING"

INHERIT_DATASTORE_ATTR  = "CEPH_HOST"
INHERIT_DATASTORE_ATTR  = "CEPH_SECRET"
INHERIT_DATASTORE_ATTR  = "CEPH_KEY"
INHERIT_DATASTORE_ATTR  = "CEPH_USER"
INHERIT_DATASTORE_ATTR  = "CEPH_CONF"
INHERIT_DATASTORE_ATTR  = "CEPH_TRASH"
INHERIT_DATASTORE_ATTR  = "POOL_NAME"

INHERIT_DATASTORE_ATTR  = "ISCSI_USER"
INHERIT_DATASTORE_ATTR  = "ISCSI_USAGE"
INHERIT_DATASTORE_ATTR  = "ISCSI_HOST"

INHERIT_IMAGE_ATTR      = "ISCSI_USER"
INHERIT_IMAGE_ATTR      = "ISCSI_USAGE"
INHERIT_IMAGE_ATTR      = "ISCSI_HOST"
INHERIT_IMAGE_ATTR      = "ISCSI_IQN"
INHERIT_IMAGE_ATTR      = "LUKS_SECRET"

INHERIT_DATASTORE_ATTR  = "GLUSTER_HOST"
INHERIT_DATASTORE_ATTR  = "GLUSTER_VOLUME"

INHERIT_DATASTORE_ATTR  = "DISK_TYPE"
INHERIT_DATASTORE_ATTR  = "ALLOW_ORPHANS"

INHERIT_DATASTORE_ATTR  = "VCENTER_ADAPTER_TYPE"
INHERIT_DATASTORE_ATTR  = "VCENTER_DISK_TYPE"
INHERIT_DATASTORE_ATTR  = "VCENTER_DS_REF"
INHERIT_DATASTORE_ATTR  = "VCENTER_DS_IMAGE_DIR"
INHERIT_DATASTORE_ATTR  = "VCENTER_DS_VOLATILE_DIR"
INHERIT_DATASTORE_ATTR  = "VCENTER_INSTANCE_ID"

INHERIT_IMAGE_ATTR      = "DISK_TYPE"
INHERIT_IMAGE_ATTR      = "VCENTER_ADAPTER_TYPE"
INHERIT_IMAGE_ATTR      = "VCENTER_DISK_TYPE"

INHERIT_VNET_ATTR       = "VLAN_TAGGED_ID"
INHERIT_VNET_ATTR       = "FILTER"
INHERIT_VNET_ATTR       = "FILTER_IP_SPOOFING"
INHERIT_VNET_ATTR       = "FILTER_MAC_SPOOFING"
INHERIT_VNET_ATTR       = "MTU"
INHERIT_VNET_ATTR       = "METRIC"
INHERIT_VNET_ATTR       = "INBOUND_AVG_BW"
INHERIT_VNET_ATTR       = "INBOUND_PEAK_BW"
INHERIT_VNET_ATTR       = "INBOUND_PEAK_KB"
INHERIT_VNET_ATTR       = "OUTBOUND_AVG_BW"
INHERIT_VNET_ATTR       = "OUTBOUND_PEAK_BW"
INHERIT_VNET_ATTR       = "OUTBOUND_PEAK_KB"
INHERIT_VNET_ATTR       = "CONF"
INHERIT_VNET_ATTR       = "BRIDGE_CONF"
INHERIT_VNET_ATTR       = "OVS_BRIDGE_CONF"
INHERIT_VNET_ATTR       = "IP_LINK_CONF"
INHERIT_VNET_ATTR       = "EXTERNAL_IP"
INHERIT_VNET_ATTR       = "EXTERNAL"
INHERIT_VNET_ATTR       = "AWS_ALLOCATION_ID"
INHERIT_VNET_ATTR       = "GATEWAY"
INHERIT_VNET_ATTR       = "VXLAN_MODE"
INHERIT_VNET_ATTR       = "VXLAN_TEP"
INHERIT_VNET_ATTR       = "VXLAN_MC"

INHERIT_VNET_ATTR       = "VCENTER_NET_REF"
INHERIT_VNET_ATTR       = "VCENTER_SWITCH_NAME"
INHERIT_VNET_ATTR       = "VCENTER_SWITCH_NPORTS"
INHERIT_VNET_ATTR       = "VCENTER_PORTGROUP_TYPE"
INHERIT_VNET_ATTR       = "VCENTER_CCR_REF"
INHERIT_VNET_ATTR       = "VCENTER_INSTANCE_ID"

#*******************************************************************************
# Transfer Manager Driver Behavior Configuration
#*******************************************************************************
# The  configuration for each driver is defined in TM_MAD_CONF. These
# values are used when creating a new datastore and should not be modified
# since they define the datastore behavior.
#   name      : name of the transfer driver, listed in the -d option of the
#               TM_MAD section
#   ln_target : determines how the persistent images will be cloned when
#               a new VM is instantiated.
#       NONE: The image will be linked and no more storage capacity will be used
#       SELF: The image will be cloned in the Images datastore
#       SYSTEM: The image will be cloned in the System datastore
#   clone_target : determines how the non persistent images will be
#                  cloned when a new VM is instantiated.
#       NONE: The image will be linked and no more storage capacity will be used
#       SELF: The image will be cloned in the Images datastore
#       SYSTEM: The image will be cloned in the System datastore
#   shared : determines if the storage holding the system datastore is shared
#            among the different hosts or not. Valid values: "yes" or "no"
#   ds_migrate : The driver allows migrations across datastores. Valid values:
#               "yes" or "no". Note: THIS ONLY APPLIES TO SYSTEM DS.
#   allow_orphans: Snapshots can live without parents. Suported values:
#        YES: Children can be orphan (no parent snapshot)
#         |- snap_1
#         |- snap_2
#         |- snap_3
#        NO: New snapshots are set active and child of the previous one
#         |- snap_1
#            |- snap_2
#               |- snap_3
#        MIXED: Snapshots are children of last snapshot reverted to
#         |- snap_1 (<--- revert)
#            |- snap_3
#            |- snap_4
#         |- snap_2
#*******************************************************************************

TM_MAD_CONF = [
    NAME = "dummy", LN_TARGET = "NONE", CLONE_TARGET = "SYSTEM", SHARED = "YES",
    DS_MIGRATE = "YES"
]

TM_MAD_CONF = [
    NAME = "lvm", LN_TARGET = "NONE", CLONE_TARGET = "SELF", SHARED = "YES",
    DRIVER = "raw"
]

TM_MAD_CONF = [
    NAME = "shared", LN_TARGET = "NONE", CLONE_TARGET = "SYSTEM", SHARED = "YES",
    DS_MIGRATE = "YES", TM_MAD_SYSTEM = "ssh", LN_TARGET_SSH = "SYSTEM",
    CLONE_TARGET_SSH = "SYSTEM", DISK_TYPE_SSH = "FILE"
]

TM_MAD_CONF = [
    NAME = "fs_lvm", LN_TARGET = "SYSTEM", CLONE_TARGET = "SYSTEM", SHARED="YES",
    DRIVER = "raw"
]

TM_MAD_CONF = [
    NAME = "qcow2", LN_TARGET = "NONE", CLONE_TARGET = "SYSTEM", SHARED = "YES",
    DS_MIGRATE = "YES", TM_MAD_SYSTEM = "ssh", LN_TARGET_SSH = "SYSTEM",
    CLONE_TARGET_SSH = "SYSTEM", DISK_TYPE_SSH = "FILE", DRIVER = "qcow2"
]

TM_MAD_CONF = [
    NAME = "ssh", LN_TARGET = "SYSTEM", CLONE_TARGET = "SYSTEM", SHARED = "NO",
    DS_MIGRATE = "YES", ALLOW_ORPHANS="YES"
]

TM_MAD_CONF = [
    NAME = "ceph", LN_TARGET = "NONE", CLONE_TARGET = "SELF", SHARED = "YES",
    DS_MIGRATE = "NO", DRIVER = "raw", ALLOW_ORPHANS="mixed",
    TM_MAD_SYSTEM = "ssh,shared", LN_TARGET_SSH = "SYSTEM", CLONE_TARGET_SSH = "SYSTEM",
    DISK_TYPE_SSH = "FILE", LN_TARGET_SHARED = "NONE",
    CLONE_TARGET_SHARED = "SELF", DISK_TYPE_SHARED = "RBD"
]

TM_MAD_CONF = [
    NAME = "iscsi_libvirt", LN_TARGET = "NONE", CLONE_TARGET = "SELF", SHARED = "YES",
    DS_MIGRATE = "NO", DRIVER = "raw"
]

TM_MAD_CONF = [
    NAME = "dev", LN_TARGET = "NONE", CLONE_TARGET = "NONE", SHARED = "YES",
    TM_MAD_SYSTEM = "ssh,shared",
    LN_TARGET_SSH = "SYSTEM", LN_TARGET_SHARED = "NONE",
    DISK_TYPE_SSH = "FILE", DISK_TYPE_SHARED = "FILE",
    CLONE_TARGET_SSH = "SYSTEM", CLONE_TARGET_SHARED =  "SELF",
    DRIVER = "raw"
]

TM_MAD_CONF = [
    NAME = "vcenter", LN_TARGET = "NONE", CLONE_TARGET = "SYSTEM", SHARED = "YES"
]

#*******************************************************************************
# Datastore Manager Driver Behavior Configuration
#*******************************************************************************
# The  configuration for each driver is defined in DS_MAD_CONF. These
# values are used when creating a new datastore and should not be modified
# since they define the datastore behavior.
#   name      : name of the transfer driver, listed in the -d option of the
#               DS_MAD section
#   required_attrs : comma separated list of required attributes in the DS
#                    template
#   persistent_only: specifies whether the datastore can only manage persistent
#                    images
#*******************************************************************************

DS_MAD_CONF = [
    NAME = "ceph",
    REQUIRED_ATTRS = "DISK_TYPE,BRIDGE_LIST",
    PERSISTENT_ONLY = "NO",
    MARKETPLACE_ACTIONS = "export"
]

DS_MAD_CONF = [
    NAME = "dev", REQUIRED_ATTRS = "DISK_TYPE", PERSISTENT_ONLY = "YES"
]

DS_MAD_CONF = [
    NAME = "iscsi_libvirt", REQUIRED_ATTRS = "DISK_TYPE,ISCSI_HOST",
    PERSISTENT_ONLY = "YES"
]

DS_MAD_CONF = [
    NAME = "dummy", REQUIRED_ATTRS = "", PERSISTENT_ONLY = "NO"
]

DS_MAD_CONF = [
    NAME = "fs", REQUIRED_ATTRS = "", PERSISTENT_ONLY = "NO",
    MARKETPLACE_ACTIONS = "export"
]

DS_MAD_CONF = [
    NAME = "lvm", REQUIRED_ATTRS = "DISK_TYPE,BRIDGE_LIST",
    PERSISTENT_ONLY = "NO"
]

DS_MAD_CONF = [
    NAME = "vcenter",
    REQUIRED_ATTRS = "VCENTER_INSTANCE_ID,VCENTER_DS_REF,VCENTER_DC_REF",
    PERSISTENT_ONLY = "NO",
    MARKETPLACE_ACTIONS = "export"
]

#*******************************************************************************
# MarketPlace Driver Behavior Configuration
#*******************************************************************************
# The  configuration for each driver is defined in MARKET_MAD_CONF. These
# values are used when creating a new marketplaces and should not be modified
# since they define the marketplace behavior.
#   name      : name of the market driver
#   required_attrs : comma separated list of required attributes in the Market
#                    template
#   app_actions: List of actions allowed for a MarketPlaceApp
#     - monitor The apps of the marketplace will be monitored
#     - create, the app in the marketplace
#     - delete, the app from the marketplace
#   public: set to yes for external marketplaces. A public marketplace can be
#   removed even if it has registered apps.
#*******************************************************************************

MARKET_MAD_CONF = [
    NAME = "one",
    SUNSTONE_NAME  = "OpenNebula.org Marketplace",
    REQUIRED_ATTRS = "",
    APP_ACTIONS = "monitor",
    PUBLIC = "yes"
]

MARKET_MAD_CONF = [
    NAME = "http",
    SUNSTONE_NAME  = "HTTP server",
    REQUIRED_ATTRS = "BASE_URL,PUBLIC_DIR",
    APP_ACTIONS = "create, delete, monitor"
]

MARKET_MAD_CONF = [
    NAME = "s3",
    SUNSTONE_NAME = "Amazon S3",
    REQUIRED_ATTRS = "ACCESS_KEY_ID,SECRET_ACCESS_KEY,REGION,BUCKET",
    APP_ACTIONS = "create, delete, monitor"
]

MARKET_MAD_CONF = [
    NAME = "linuxcontainers",
    SUNSTONE_NAME = "LinuxContainers.org",
    REQUIRED_ATTRS = "",
    APP_ACTIONS = "monitor",
    PUBLIC = "yes"
]

MARKET_MAD_CONF = [
    NAME = "turnkeylinux",
    SUNSTONE_NAME = "TurnkeyLinux",
    REQUIRED_ATTRS = "",
    APP_ACTIONS = "monitor",
    PUBLIC = "yes"
]

MARKET_MAD_CONF = [
    NAME = "dockerhub",
    SUNSTONE_NAME = "DockerHub",
    REQUIRED_ATTRS = "",
    APP_ACTIONS = "monitor",
    PUBLIC = "yes"
]

#*******************************************************************************
# Authentication Driver Behavior Definition
#*******************************************************************************
# The configuration for each driver is defined in AUTH_MAD_CONF. These
# values must not be modified since they define the driver behavior.
#   name            : name of the auth driver
#
#   password_change : allow the end users to change their own password. Oneadmin
#                     can still change other user's passwords
#
#   driver_managed_groups : allow the driver to set the user's group even after
#                     user creation. In this case addgroup, delgroup and chgrp
#                     will be disabled, with the exception of chgrp to one of
#                     the groups in the list of secondary groups
#
#   driver_managed_group_admin : when set to "NO" user needs to manage group
#                     admin membership manually; when "YES" group admin
#                     membership is managed by the auth driver
#                     (see ldap_auth.conf)
#
#   max_token_time  : limit the maximum token validity, in seconds. Use -1 for
#                     unlimited maximum, 0 to disable login tokens
#*******************************************************************************

AUTH_MAD_CONF = [
    NAME = "core",
    PASSWORD_CHANGE = "YES",
    DRIVER_MANAGED_GROUPS = "NO",
    DRIVER_MANAGED_GROUP_ADMIN = "NO",
    MAX_TOKEN_TIME = "-1"
]

AUTH_MAD_CONF = [
    NAME = "public",
    PASSWORD_CHANGE = "NO",
    DRIVER_MANAGED_GROUPS = "NO",
    DRIVER_MANAGED_GROUP_ADMIN = "NO",
    MAX_TOKEN_TIME = "-1"
]

AUTH_MAD_CONF = [
    NAME = "ssh",
    PASSWORD_CHANGE = "YES",
    DRIVER_MANAGED_GROUPS = "NO",
    DRIVER_MANAGED_GROUP_ADMIN = "NO",
    MAX_TOKEN_TIME = "-1"
]

AUTH_MAD_CONF = [
    NAME = "x509",
    PASSWORD_CHANGE = "NO",
    DRIVER_MANAGED_GROUPS = "NO",
    DRIVER_MANAGED_GROUP_ADMIN = "NO",
    MAX_TOKEN_TIME = "-1"
]

AUTH_MAD_CONF = [
    NAME = "ldap",
    PASSWORD_CHANGE = "YES",
    DRIVER_MANAGED_GROUPS = "YES",
    DRIVER_MANAGED_GROUP_ADMIN = "YES",
    MAX_TOKEN_TIME = "86400"
]

AUTH_MAD_CONF = [
    NAME = "server_cipher",
    PASSWORD_CHANGE = "NO",
    DRIVER_MANAGED_GROUPS = "NO",
    DRIVER_MANAGED_GROUP_ADMIN = "NO",
    MAX_TOKEN_TIME = "-1"
]

AUTH_MAD_CONF = [
    NAME = "server_x509",
    PASSWORD_CHANGE = "NO",
    DRIVER_MANAGED_GROUPS = "NO",
    DRIVER_MANAGED_GROUP_ADMIN = "NO",
    MAX_TOKEN_TIME = "-1"
]

#*******************************************************************************
# Virtual Network Driver Behavior Definition
#*******************************************************************************
# The configuration for each driver is defined in VN_MAD_CONF. These
# values must not be modified since they define the driver behavior.
#   name        : name of the auth driver
#   BRIDGE_TYPE : define the technology used by the driver
#*******************************************************************************

VN_MAD_CONF = [
    NAME = "dummy",
    BRIDGE_TYPE = "linux"
]

VN_MAD_CONF = [
    NAME = "802.1Q",
    BRIDGE_TYPE = "linux"
]

VN_MAD_CONF = [
    NAME = "ebtables",
    BRIDGE_TYPE = "linux"
]

VN_MAD_CONF = [
    NAME = "fw",
    BRIDGE_TYPE = "linux"
]

VN_MAD_CONF = [
    NAME = "ovswitch",
    BRIDGE_TYPE = "openvswitch"
    #openvswitch or openvswitch_dpdk
]

VN_MAD_CONF = [
    NAME = "vxlan",
    BRIDGE_TYPE = "linux"
]

VN_MAD_CONF = [
    NAME = "vcenter",
    BRIDGE_TYPE = "vcenter_port_groups"
]

VN_MAD_CONF = [
    NAME = "ovswitch_vxlan",
    BRIDGE_TYPE = "openvswitch"
]

VN_MAD_CONF = [
    NAME = "bridge",
    BRIDGE_TYPE = "linux"
]

VN_MAD_CONF = [
    NAME = "elastic",
    BRIDGE_TYPE = "linux"
]
