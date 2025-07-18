"""A package that replicates some of the functionality of Pine."""

from typing import Any

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root() -> dict[str, str]:
    """Read the root endpoint.

    Returns
    -------
    dict[str, str]
        A dictionary with a simple greeting.

    """
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str | None = None) -> dict[str, Any]:
    """Read an item by its ID.

    Parameters
    ----------
    item_id : int
        The unique identifier for the item.
    q : str | None, optional
        An optional query string, by default None.

    Returns
    -------
    dict[str, Any]
        A dictionary containing the item ID and the query string.

    """
    return {"item_id": item_id, "q": q}
