
%% Node selection
% Written by Shunxin Guo
% 2019-11-29
%% Inputs:
% acc: the nodes selected and the probability of nodes
% input_data: training data without labels
% model: 
% tree: the tree hierarchy
%% Output
function[select] = RecursiveLeaf(acc,input_data,model,tree,k)
currentNode = acc(1,1);
currentNodeAcc = acc(1,2);
       if(~ismember(currentNode,tree_LeafNode(tree)))
           [~,~,d_v] = predict(1,sparse(input_data),model{currentNode}, '-b 1 -q');
           [n_d_v,IX]=sort(d_v,'descend');
           currentParentNode = currentNode;
           [~,l] = size(IX);
           if(l>= k)
           for i = 1:k
               currentNodeID = IX(1,i);
               mid_pro = n_d_v(1,i);
               currentNode = model{currentParentNode}.Label(currentNodeID);
               acc(i,:) = [currentNode,mid_pro];
               select(i,:) = [currentNode,mid_pro,currentNodeAcc * acc(i,2)]; %Stores the product of the probabilities of a child node and its parent node
           end
           else
               currentNodeID = IX(1,1);
               mid_pro = n_d_v(1,1);
               currentNode = model{currentParentNode}.Label(currentNodeID);
               acc(1,:) = [currentNode,mid_pro];
               select(1,:) = [currentNode,mid_pro,currentNodeAcc^2 * acc(1,2)];
           end
        else
            select = [currentNode,currentNodeAcc,currentNodeAcc;currentNode,currentNodeAcc,currentNodeAcc];
       end
end
