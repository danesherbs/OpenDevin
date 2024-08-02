import asyncio

from opendevin.controller.agent import Agent
from opendevin.controller.state.state import State
from opendevin.core.main import run_agent_controller


def fake_user_response_fn(state: State) -> str:
    return "This is a dummy user response."


def run(agent: Agent, instructions: str) -> State:
    return asyncio.run(
        run_agent_controller(
            agent=agent,
            task_str=instructions,
            max_iterations=1,
            exit_on_message=False,
            fake_user_response_fn=fake_user_response_fn,
        )
    )


if __name__ == "__main__":
    run(
        agent=Agent.get_cls("CodeActAgent"),
        instructions="This is a dummy task.",
    )
