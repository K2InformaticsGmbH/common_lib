-module(cl_throttler).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-export([throttle/1, unthrottle/1, throttling/1]).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

throttle(SessionPid) ->
    ets:insert(?MODULE, {SessionPid, true}).

unthrottle(SessionPid) ->
    ets:delete(?MODULE, SessionPid).

throttling(SessionPid) ->
    ets:lookup(?MODULE, SessionPid) =:= [{SessionPid, true}].

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    ets:new(?MODULE, [public, named_table]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
