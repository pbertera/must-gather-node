# OpenShift must-gather node

This repo contains an image suitable to build easy to customize [must-gather](https://github.com/openshift/must-gather) images that can be used to retrieve node-specific informations and data.

This image deploys a temporary DaemonSet on the cluster, the deployed container execute commands on the node and retrive the defined files.

- Executed commands output are saved into the folder `<MUST-GATHER-ROOT>/nodes/<NODE-NAME>/commands/`
- Files retrieved from the nodes are saved into the folder `<MUST-GATHER-ROOT>/nodes/<NODE-NAME>/files/`

## Customization

This image can be modified to execute custom commands and gather specific files.

### Defining the commands

Commands to execute on the nodes can be defined editing the file `resources/commands`. This file contains a lis of commands, each per line.

Is possible to define an OS-specific list of commands creating the file `resources/commands.<OS-TYPE>`. The operating system type is determined by the node label `node.openshift.io/os_id`. If the label `node.openshift.io/os_id` is not present the script looks at the file `resources/commands`.

For example:

- on a node with label `node.openshift.io/os_id: rhel` the OS-specific commands are defined into the file `resources/commands.rhel`
- on a node with label `node.openshift.io/os_id: rhcos` the OS-specific commands are defined into the file `resources/commands.rhcos`
- if the label `node.openshift.io/os_id` is missing from a node the commands are defined into the file `resources/commands`
- if both the OS-specific and the generic commands file are defined the OS-specific will take precedence and the generic will be ignored.

### Defining the files to retrieve

Files to download from the nodes can be defined editing the file `resources/files`. This file contains a list of files/directory to download from the nodes.

As the commands, if an OS-specific file matching the node label `node.openshift.io/os_id` the OS-specific file will be used.

## Usage

To use the `must-gather-node` image you can use the `oc adm must-gather` command:

```
$ oc adm must-gather --image <your-image>
```

oc adm must-gather --image-stream=openshift/must-gather
