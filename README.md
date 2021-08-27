# OpenShift must-gather node

This repo contains an image suitable to build a customized [must-gather](https://github.com/openshift/must-gather) image that can be used to retrieve node-specific informations and data.

This image deploys a temporary `DaemonSet` on the cluster. The deployed pods are used to execute custom commands on the nodes and retrieve specific files.

- Executed commands output are saved into the folder `<MUST-GATHER-ROOT>/nodes/<NODE-NAME>/commands/`
- Files retrieved from the nodes are saved into the folder `<MUST-GATHER-ROOT>/nodes/<NODE-NAME>/files/`

Customizing this must-gather image is easy do define:

- a list of files to gather, from all the nodes
- a list of files to gather, specific per node OS
- a list of files to gather, specific to the node role
- a list of commands to execute on all the nodes
- a list of commands to execute on the nodes, specific per node OS
- a list of commands to execute on the nodes, specific for the node role

## Customization

This image can be modified to execute custom commands and gather specific files.

### Defining the commands

Commands to execute on the nodes can be defined editing the file `resources/commands*`.
Those files should containe a list of commands, each per line.

Example:

```
sestatus
dmesg
```

* Is possible to define an OS-specific list of commands creating the file `resources/commands.os-<OS-TYPE>`. Eg. `resources/commands.os-rhcos`
  The node operating system type is determined by the node label `node.openshift.io/os_id`.
* Is possible to define a role-specific list of commands creating the file `resources/commands.role-<ROLE>`. Eg. `resources/commands.os-master`

For example:

- the file `resources/commands` contains a list of commands to execute on all the nodes
- the commands from the file `resources/commands.role-master` are executed only on master nodes
- the commands from the file `resources/commands.os-rhel` are executed only on RHEL nodes (nodes with label `node.openshift.io/os_id: rhel`)
- the commands from the file `resources/commands.os-rhcos` are executed only on RHCOS nodes (nodes with label `node.openshift.io/os_id: rhcos`)
- the commands from the file `resources/commands.role-master` are executed only on nodes with role master

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

For example:

- the file `resources/files` contains a list of files and directory to retrieve from all the nodes
- the file `resources/files.role-master` contains a list of files and directory to retrieve from master nodes
- the file `resources/files.os-rhel` contains a list of files and directory to retrieve from RHEL nodes (nodes with label `node.openshift.io/os_id: rhel`)
- the file `resources/files.os-rhcos` contains a list of files and directory to retrieve from RHCOS nodes (nodes with label `node.openshift.io/os_id: rhcos`)

## Usage

To use the `must-gather-node` image you can use the `oc adm must-gather` command:

```
$ oc adm must-gather --image <your-image>
```

To run a "combinated" must-gater with the original plugin:

```
$ oc adm must-gather --image <your-image> --image-stream=openshift/must-gather
```
