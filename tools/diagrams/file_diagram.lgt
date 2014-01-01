%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <http://logtalk.org/>  
%  Copyright (c) 1998-2014 Paulo Moura <pmoura@logtalk.org>
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%  
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%  
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%  
%  Additional licensing terms apply per Section 7 of the GNU General
%  Public License 3. Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(file_diagram(Format),
	imports(diagram(Format))).

	:- info([
		version is 2.0,
		author is 'Paulo Moura',
		date is 2014/01/01,
		comment is 'Predicates for generating file loading dependency diagrams.',
		argnames is ['Format']
	]).

	output_file(Path, Basename, Directory, Options) :-
		(	member(directory_paths(true), Options) ->
			^^output_node(Path, Basename, [Directory], file, Options)
		;	^^output_node(Path, Basename, [], file, Options)
		),
		fail.
	output_file(Path, _, _, Options) :-
		logtalk::loaded_file_property(Path, parent(Parent)),
		^^output_edge(Parent, Path, [loads], loads_file, Options),
		fail.
	output_file(_, _, _, _).

	merge_options(UserOptions, Options) :-
		% by default, don't print directory paths:
		(member(directory_paths(DirectoryPaths), UserOptions) -> true; DirectoryPaths = false),
		% by default, print current date:
		(member(date(Date), UserOptions) -> true; Date = true),
		% by default, print relation labels:
		(member(relation_labels(Relations), UserOptions) -> true; Relations = false),
		% by default, write diagram to the current directory:
		(member(output_path(OutputPath), UserOptions) -> true; OutputPath = './'),
		% by default, don't exclude any source files:
		(member(exclude_files(ExcludedFiles), UserOptions) -> true; ExcludedFiles = []),
		% by default, don't exclude any library sub-directories:
		(member(exclude_libraries(ExcludedLibraries), UserOptions) -> true; ExcludedLibraries = []),
		Options = [
			directory_paths(DirectoryPaths), date(Date), relation_labels(Relations),
			output_path(OutputPath),
			exclude_files(ExcludedFiles), exclude_libraries(ExcludedLibraries)].

	output_file_path(Name0, Options, Format, OutputPath) :-
		atom_concat(Name0, '_file_diagram', Name),
		^^output_file_path(Name, Options, Format, OutputPath).

	member(Option, [Option| _]) :-
		!.
	member(Option, [_| Options]) :-
		member(Option, Options).

:- end_object.
