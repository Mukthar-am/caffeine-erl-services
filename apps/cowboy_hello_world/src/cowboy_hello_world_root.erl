%%%-------------------------------------------------------------------
%%% @author arpit
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Apr 2018 3:39 PM
%%%-------------------------------------------------------------------
-module(cowboy_hello_world_root).
-author("arpit").

-import(
jsx,[decode/1]
).

%% API
-export([
  init/2,
  allowed_methods/2,
  content_types_provided/2,
  content_types_accepted/2
]).

-export([
  print_json/2,
  return_json/2
]).


-record(state, {op}).

init(Req, Opts) ->
  [Op | _] = Opts,
  State = #state{op=Op},
  {cowboy_rest, Req, State}.


allowed_methods(Req, State) ->
  Methods = [<<"GET">>, <<"POST">>],
  {Methods, Req, State}.


content_types_provided(Req, State) ->
  {[
    {<<"text/plain">>, print_json},
    {<<"application/json">>, return_json}
  ], Req, State}.

content_types_accepted(Req, State) ->
  {[
    {<<"text/plain">>, print_json},
    {<<"application/json">>, return_json}
  ], Req, State}.


print_json(Req, #state{op=Op} = State) ->
  {Body, Req1, State1} = case Op of
                           get ->
                             get_record_list(Req, State)
                         end,
  {Body, Req1, State1}.


return_json(Req, #state{op=Op} = State) ->
  {Body, Req1, State1} = case Op of
                           post ->
                             return_record_list(Req, State)
                         end,
  {Body, Req1, State1}.


get_record_list(Req, State) ->
%%  {ok} = application:get_env(cowboy_hello_world_root),
  Body = "Arpit",
  {Body, Req, State}.


return_record_list(Req, State) ->
  {ok, Body1, Req2} = cowboy_req:body(Req),
%%  io:format([Req2]),
%%  io:format([Body1]),
  Req_Body_decoded = decode(Body1),
%%  io:format([Req_Body_decoded]),
  [{<<"test">>,Test}] = Req_Body_decoded,
  Test1 = binary_to_list(Test),
  io:format("Title1 is ~p ~n ", [Test1]),
  Res1 = cowboy_req:set_resp_body("{\"test\":\"gr98732848\"}", Req2),
  Res2 = cowboy_req:delete_resp_header(<<"content-type">>, Res1),
  Res3 = cowboy_req:set_resp_header(<<"content-type">>, <<"application/json">>, Res2),
%%  Body1="{\"name\":\"Arpit\"}",
  {true, Res3, State}.