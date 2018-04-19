%%%-------------------------------------------------------------------
%% @doc cowboy_hello_world public API
%% @end
%%%-------------------------------------------------------------------

-module(cowboy_hello_world_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    {ok, Pid} = cowboy_hello_world_sup:start_link(),
    Routes = [ {
        '_',
        [
            {"/", cowboy_hello_world_root, [help]},
            {"/gethelp/:id", cowboy_hello_world_root, [get]},
            {"/testbody/", cowboy_hello_world_root, [post]}
        ]
    } ],
    Dispatch = cowboy_router:compile(Routes),

    NumAcceptors = 10,
    TransOpts = [ {ip, {0,0,0,0}}, {port, 2938} ],
    ProtoOpts = [{env, [{dispatch, Dispatch}]}],

    {ok, _} = cowboy:start_http(chicken_poo_poo,
        NumAcceptors, TransOpts, ProtoOpts),

    {ok, Pid}.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
