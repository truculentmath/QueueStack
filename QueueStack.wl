(* ::Package:: *)

(* ::Title:: *)
(*QueueStack*)


(* ::Text:: *)
(*Implementation of a queue and a stack. Code adapted from Carl Woll's answers:*)
(*	https://mathematica.stackexchange.com/questions/198341/implementing-core-data-structures/198345 *)
(*	https://mathematica.stackexchange.com/questions/151948/remove-element-from-list-and-store-it-in-variable*)


BeginPackage["QueueStack`"];


(* ::Subtitle:: *)
(*Usage Messages*)


QueueList::usage = "QueueList[ID] returns the queue in list form. Avoid doing this, but handy for debugging.";

QueueLength::usage = "QueueLength[ID] returns the number of elements in the queue.";

QueueEmpty::usage = "QueueEmpty[ID] returns True if the queue has no elements, and False otherwise.";

QueuePush::usage = "QueuePush[ID,e] puts the element e at the back of the queue.";

QueuePop::usage = "QueuePop[ID] removes the first element from the queue and returns it.";

QueuePeek::usage = "QueuePeek[ID] returns the first element from the queue without removing it.";

QueueClear::usage = "QueueClear[ID] and QueueClear[ListOfIDs] unsets the queues.";

QueueSelect::usage = "QueueSelect[ID, newID, crit] returns a queue (with id newID) \
containing the elements of the stack that satisfy crit (a function). Order is preserved from the \
original stack. QueueSelect[ID, newID, crit, n] returns the first n elements satisfying crit.";

StackList::usage = "StackList[ID] returns the stack in list form. Avoid doing this, but handy for debugging.";

StackLength::usage = "StackLength[ID] returns the number of elements in the stack.";

StackEmpty::usage = "StackEmpty[ID] returns True if the stack has no elements, and False otherwise.";

StackPush::usage = "StackPush[ID,e] put the element e at the top of the stack.";

StackPop::usage = "StackPop[ID] removes the top element from the stack and returns it.";

StackPeek::usage = "StackPeek[ID] returns the top element from the stack without removing it.";

StackClear::usage = "StackClear[ID] and StackClear[ListOfIDs] unsets the stacks.";

StackSelect::usage = "StackSelect[ID, newID, crit] returns a stack (with id newID) \
containing the elements of the stack that satisfy crit (a function). Order is reversed from the \
original stack. StackSelect[ID, newID, crit, n] returns the top n elements satisfying crit.";


(* ::Subtitle:: *)
(*Begin Private*)


Begin["`Private`"]


(* ::Subtitle:: *)
(*Actual Code*)


$Queue[_]=Association[];

QueueList[queueID_]:=Values[$Queue[queueID]];

QueueLength[queueID_] := Length[$Queue[queueID]];

QueueEmpty[queueID_] := $Queue[queueID]===Association[];

QueuePush[queueID_,foo_]:=
	Module[{},
		AssociateTo[$Queue[queueID],$ModuleNumber->foo];
		Null];

QueuePeek[queueID_]:=
	If[QueueEmpty[queueID],
		Missing["Empty"],
		First[Values[Take[$Queue[queueID],1]]]];

QueuePop[queueID_]:=
	If[QueueEmpty[queueID],
		Missing["Empty"],
		With[{first=Take[$Queue[queueID],1]},
			KeyDropFrom[$Queue[queueID],Keys@first];
			first[[1]]]];

QueueClear[queueID_]:= Quiet[Unset[$Queue[queueID]];,Unset::norep];
QueueClear[queueIDs_List]:=Map[QueueClear,queueIDs];


QueueSelect[queueID_,newID_,crit_]:=Block[{},($Queue[newID]=Select[$Queue[queueID],crit]);
Null];
QueueSelect[queueID_,newID_,crit_,n_Integer]:=Block[{},($Queue[newID]=Select[$Queue[queueID],crit,n]);
Null];


$Stack[_]=List[];

StackList[stackID_]:=Flatten[$Stack[stackID]];

StackEmpty[stackID_] := ($Stack[stackID]==={});

StackLength[stackID_]:=Length[StackList[stackID]];

StackPush[stackID_,foo_]:=Block[{},$Stack[stackID]={$Stack[stackID],foo};Null];

StackPop[stackID_]:=Replace[$Stack[stackID],{{s_,e_}:>($Stack[stackID]=s;e),_->Missing["Empty"]}];

StackPeek[stackID_]:= If[StackEmpty[stackID],Missing["Empty"],Last[$Stack[stackID]]];

StackClear[stackID_]:= Quiet[Unset[$Stack[stackID]];,Unset::norep];
QueueClear[stackIDs_List]:=Map[StackClear,stackIDs];


StackSelect[stackID_,newstackID_,criteria_,n_Integer?Positive]:=Module[{search},
search[stack_,L_List,n]:=Block[{},$Stack[newstackID]=L;Null];
search[{},L_List,lenL_]:=Block[{},$Stack[newstackID]=L;Null];
search[stack_,L_List,lenL_]:=With[{e=Last[stack]},If[criteria[e],search[First[stack],{L,e},lenL+1],search[First[stack],L,lenL]]];

Block[{$IterationLimit=Infinity},search[$Stack[stackID],{},0]]];

StackSelect[stackID_,newstackID_,criteria_]:=Module[{search},
search[{},L_List]:=Block[{},$Stack[newstackID]=L;Null];
search[stack_,L_List]:=With[{e=Last[stack]},If[criteria[e],search[First[stack],{L,e}],search[First[stack],L]]];

Block[{$IterationLimit=Infinity},search[$Stack[stackID],{}]]];




(* ::Subtitle:: *)
(*End the package*)


End[]
EndPackage[]
