%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <https://logtalk.org/>  
%  Copyright 1998-2018 Paulo Moura <pmoura@logtalk.org>
%  
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%  
%      http://www.apache.org/licenses/LICENSE-2.0
%  
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(parent).

	:- public(get_local/1).
	get_local(Local) :-
		::local(Local).

	:- protected(local/1).
	local(parent).

:- end_object.


:- object(prototype,
	extends(parent)).

	:- public(test/1).
	test(Local) :-
		% ^^/2 goals, aka super calls, preserve self
		^^get_local(Local).

	:- public(wrong/1).
	wrong(Local) :-
		% ::/2 messages reset self to receiver 
		parent::get_local(Local).

	local(prototype).

:- end_object.