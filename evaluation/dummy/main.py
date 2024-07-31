import asyncio

from opendevin.controller.state.state import State
from opendevin.core.main import main
from opendevin.runtime.docker.local_box import LocalBox


def fake_user_response_fn(state: State) -> str:
    return "This is a dummy user response."


def run(instructions: str) -> State:
    return asyncio.run(
        main(
            task_str=instructions,
            exit_on_message=False,
            fake_user_response_fn=fake_user_response_fn,
            sandbox=LocalBox(),
        )
    )


if __name__ == "__main__":
    run(instructions="This is a dummy task.")
