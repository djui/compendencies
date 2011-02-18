%%% @doc Compendencies - Compilation dependencies, lists files needed to compile
%%% a beam file.
%%% @author Uwe Dauernheim <uwe@dauernheim.net>
-module(compendencies).

-author("Uwe Dauernheim <uwe@dauernheim.net>").

-export([go/1]).

%% @doc Find dependent files based on loaded module name.
go(Mod) when is_atom(Mod) ->
  deps(Mod, code:which(Mod));
%% @doc Find dependent files based on beam file path.
go(Beam) when is_list(Beam) ->
  [_, {module, Mod}, _] = beam_lib:info(Beam),
  deps(Mod, Beam).

%% @doc Get abstract code and filter for included files.
%% @private
deps(Mod, Beam) ->
  AC = ac(Mod, Beam),
  Files = [File || {attribute, _Line, file, {File, 1}} <- AC],
  Files.

%% @doc Get and check the abstract code chunk from the beam file.
%% @private
ac(Mod, Beam) ->
  AC = beam_lib:chunks(Beam, [abstract_code]),
  check_ac(Mod, AC).

%% @doc Check the result of getting the abstract code chunk.
%% @private
check_ac(Mod, {ok, {Mod, [{abstract_code, {raw_abstract_v1, AC}}]}}) ->
  AC;
%% No debug_info?
check_ac(Mod, {ok, {Mod, [{abstract_code, no_abstract_code}]}}) ->
  throw({error, {no_abstract_code, Mod}});
%% file_error, not_a_beam_file, invalid_beam_file, missing_chunk, invalid_chunk,
%% chunk_too_big
check_ac(_Mod, {error, beam_lib, Reason}) ->
  throw({error, Reason}).
