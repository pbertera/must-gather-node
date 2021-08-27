# OpenShift must-gather node

This repo contains an image suitable to build easy to customize [must-gather](https://github.com/openshift/must-gather) images that can be used to retrieve node-specific informations and data.

This image deploys a temporary DaemonSet on the cluster, the deployed container execute commands on the node and retrive the defined files.

- Executed commands output are saved into the folder `<MUST-GATHER-ROOT>/nodes/<NODE-NAME>/commands/`
- Files retrieved from the nodes are saved into the folder `<MUST-GATHER-ROOT>/nodes/<NODE-NAME>/files/`

This must-gather image is designed to easily define:
- a list of files to gather from all the nodes
- a list of files to gather, specific per node OS
- a list of files to gather, specific to the node role
- a list of commands to execute on all the nodes
- a list of commands to execute on the nodes, specific per node OS
- a list of commands to execute on the nodes, specific for the node role

## Customization

This image can be modified to execute custom commands and gather specific files.

### Defining the commands

Commands to execute on the nodes can be defined editing the file `resources/commands`. This file contains a lis of commands, each per line.

Example:

```
sestatus
dmesg
```

* Is possible to define an OS-specific list of commands creating the file `resources/commands.os-<OS-TYPE>`. Eg. `resources/commands.os-rhcos`
  The node operating system type is determined by the node label `node.openshift.io/os_id`.
* Is possible to define a role-specific list of commands creating the file `resources/commands.role-<ROLE>`. Eg. `resources/commands.os-master`

For example:

- the commands from the file `resources/commands.role-master` is executed only on master nodes
- on a node with label `node.openshift.io/os_id: rhel` the OS-specific commands are defined into the file `resources/commands.os-rhel`
- on a node with label `node.openshift.io/os_id: rhcos` the OS-specific commands are defined into the file `resources/commands.os-rhcos`
- if the label `node.openshift.io/os_id` is missing or is not matching any `resources/commands.*`, only the commands from `resources/commands` will be executed

### Defining the files to retrieve

Files to download from the nodes can be defined editing the file `resources/files`. This file contains a list of files/directory to download from the nodes.

Example:
```
/etc/resolv.conf
/etc/containers/
```

* Is possible to define an OS-specific list of files to gather creating the file `resources/files.os-<OS-TYPE>`. Eg. `resources/commands.files-rhcos`
  The node operating system type is determined by the node label `node.openshift.io/os_id`
* Is possible to define a role-specific list of files to gather creating the file `resources/files.role-<ROLE>`. Eg. `resources/commands.files-master`

## Usage

To use the `must-gather-node` image you can use the `oc adm must-gather` command:

```
$ oc adm must-gather --image <your-image>
```

To run a "combinated" must-gater with the original plugin:

```
$ oc adm must-gather --image <your-image> --image-stream=openshift/must-gather
```
