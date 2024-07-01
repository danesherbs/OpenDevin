import asyncio

from opendevin.controller.state.state import State
from opendevin.core.main import main
from opendevin.runtime.docker.local_box import LocalBox


def fake_user_response_fn(state: State) -> str:
    return "This is a dummy response."


def run(agent: str) -> None:
    state: State = asyncio.run(
        main(
            instruction="Hello!",
            fake_user_response_fn=fake_user_response_fn,
            sandbox=LocalBox(),
        )
    )

    assert state is not None, "State should not be None."


if __name__ == "__main__":
    run(agent="PlannerAgent")
