all:
  hosts:
%{~ for node in controllers }
    ${ node.name }:
      ansible_host: ${ node.ip }
%{~ endfor }
%{~ for node in workers }
    ${ node.name }:
      ansible_host: ${ node.ip }
%{~ endfor }
  children:
    kube_control_plane:
      hosts:
%{~ for node in controllers }
        ${ node.name }
%{~ endfor }
    kube_node:
      hosts:
%{~ for node in workers }
        ${ node.name }
%{~ endfor }
    etcd:
      hosts:
%{~ for node in controllers }
        ${ node.name }
%{~ endfor }
%{~ for node in workers }
        ${ node.name }
%{~ endfor }
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}