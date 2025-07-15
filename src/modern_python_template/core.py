"""Core functionality for the modern Python template."""

import logging
from typing import Any

from pydantic import BaseModel, ConfigDict, Field
from rich.console import Console
from rich.table import Table

logger = logging.getLogger(__name__)
console = Console()


class DataModel(BaseModel):
    """A sample data model using Pydantic."""
    
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )
    
    name: str = Field(..., min_length=1, max_length=100, description="Name of the item")
    value: int | float = Field(..., gt=0, description="Positive numeric value")
    tags: list[str] = Field(default_factory=list, description="List of tags")
    metadata: dict[str, Any] | None = Field(None, description="Additional metadata")
    
    def __str__(self) -> str:
        """Return string representation."""
        return f"DataModel(name='{self.name}', value={self.value})"


def greet(name: str = "World") -> str:
    """
    Generate a greeting message.
    
    Args:
        name: Name to greet (default: "World")
        
    Returns:
        Greeting message
        
    Example:
        >>> greet("Alice")
        'Hello, Alice!'
    """
    if not name or not name.strip():
        name = "World"
    
    message = f"Hello, {name.strip()}!"
    logger.info("Generated greeting: %s", message)
    return message


def process_data(data: list[dict[str, Any]]) -> list[DataModel]:
    """
    Process a list of data dictionaries into validated DataModel objects.
    
    Args:
        data: List of dictionaries to process
        
    Returns:
        List of validated DataModel objects
        
    Raises:
        ValueError: If data is empty or invalid
        
    Example:
        >>> data = [{"name": "item1", "value": 42}]
        >>> result = process_data(data)
        >>> len(result)
        1
    """
    if not data:
        raise ValueError("Data cannot be empty")
    
    processed = []
    for item in data:
        try:
            model = DataModel(**item)
            processed.append(model)
            logger.debug("Processed item: %s", model)
        except Exception as e:
            logger.error("Failed to process item %s: %s", item, e)
            raise
    
    logger.info("Successfully processed %d items", len(processed))
    return processed


def display_data(data: list[DataModel]) -> None:
    """
    Display data in a formatted table using Rich.
    
    Args:
        data: List of DataModel objects to display
    """
    if not data:
        console.print("[yellow]No data to display[/yellow]")
        return
    
    table = Table(title="Data Overview")
    table.add_column("Name", style="cyan")
    table.add_column("Value", justify="right", style="magenta")
    table.add_column("Tags", style="green")
    
    for item in data:
        tags_str = ", ".join(item.tags) if item.tags else "[dim]none[/dim]"
        table.add_row(item.name, str(item.value), tags_str)
    
    console.print(table)


def calculate_statistics(data: list[DataModel]) -> dict[str, Any]:
    """
    Calculate basic statistics for the data.
    
    Args:
        data: List of DataModel objects
        
    Returns:
        Dictionary containing statistics
    """
    if not data:
        return {"count": 0, "total": 0, "average": 0, "min": 0, "max": 0}
    
    values = [item.value for item in data]
    
    return {
        "count": len(data),
        "total": sum(values),
        "average": sum(values) / len(values),
        "min": min(values),
        "max": max(values),
    }
