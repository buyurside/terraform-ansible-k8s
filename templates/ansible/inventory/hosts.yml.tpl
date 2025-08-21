---
inventory:
  hosts:
%{~ for node in masters }
    ${ node.name }:
      ansible_host: ${ node.ip }
      ansible_user: user
%{~ endfor }
%{~ for node in workers }
    ${ node.name }:
      ansible_host: ${ node.ip }
      ansible_user: user
%{~ endfor }
  children:
    k8s-master-nodes:
      hosts:
%{~ for node in masters }
        ${ node.name }:
%{~ endfor }
    k8s-worker-nodes:
      hosts:
%{~ for node in workers }
        ${ node.name }:
%{~ endfor }
    k8s-etcd-nodes:
      hosts:
%{~ for node in masters }
        ${ node.name }:
%{~ endfor }
%{~ for node in workers }
        ${ node.name }:
%{~ endfor }
    k8s-cluster:
      children:
        k8s-master-nodes:
        k8s-worker-nodes:
    k8s-control-plane: # alias to "k8s-master-nodes"
    	children:
        k8s-master-nodes: