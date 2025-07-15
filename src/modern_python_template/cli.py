"""Command line interface for the modern Python template."""

import json
import logging
import sys
from pathlib import Path

import click
from rich.console import Console
from rich.logging import RichHandler

from modern_python_template.core import (
    calculate_statistics,
    display_data,
    greet,
    process_data,
)

console = Console()


def setup_logging(verbose: bool = False) -> None:
    """Setup logging configuration."""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(message)s",
        datefmt="[%X]",
        handlers=[RichHandler(rich_tracebacks=True)],
    )


@click.group()
@click.version_option()
@click.option(
    "--verbose",
    "-v",
    is_flag=True,
    help="Enable verbose logging",
)
def cli(verbose: bool) -> None:
    """Modern Python Template CLI."""
    setup_logging(verbose)


@cli.command()
@click.argument("name", default="World")
def hello(name: str) -> None:
    """Say hello to someone."""
    message = greet(name)
    console.print(f"[bold green]{message}[/bold green]")


@cli.command()
@click.argument("input_file", type=click.Path(exists=True, path_type=Path))
@click.option(
    "--output",
    "-o",
    type=click.Path(path_type=Path),
    help="Output file for results",
)
@click.option(
    "--stats",
    is_flag=True,
    help="Calculate and display statistics",
)
def process(input_file: Path, output: Path | None, stats: bool) -> None:
    """Process data from a JSON file."""
    try:
        # Read input data
        with input_file.open() as f:
            data = json.load(f)
        
        if not isinstance(data, list):
            raise click.ClickException("Input data must be a list of objects")
        
        # Process the data
        processed_data = process_data(data)
        
        # Display the data
        console.print(f"[bold blue]Processed {len(processed_data)} items:[/bold blue]")
        display_data(processed_data)
        
        # Calculate statistics if requested
        if stats:
            statistics = calculate_statistics(processed_data)
            console.print("\n[bold yellow]Statistics:[/bold yellow]")
            for key, value in statistics.items():
                console.print(f"  {key}: {value}")
        
        # Save output if specified
        if output:
            output_data = [
                {
                    "name": item.name,
                    "value": item.value,
                    "tags": item.tags,
                    "metadata": item.metadata,
                }
                for item in processed_data
            ]
            
            with output.open("w") as f:
                json.dump(output_data, f, indent=2)
            
            console.print(f"[green]Results saved to {output}[/green]")
    
    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")
        sys.exit(1)


@cli.command()
def demo() -> None:
    """Run a demonstration of the template functionality."""
    console.print("[bold blue]Modern Python Template Demo[/bold blue]")
    
    # Create sample data
    sample_data = [
        {"name": "Alpha", "value": 42, "tags": ["important", "first"]},
        {"name": "Beta", "value": 23.5, "tags": ["second"]},
        {"name": "Gamma", "value": 100, "tags": ["important", "large"]},
    ]
    
    console.print("\n[yellow]Sample data:[/yellow]")
    console.print(json.dumps(sample_data, indent=2))
    
    # Process the data
    processed = process_data(sample_data)
    
    console.print("\n[green]Processed data:[/green]")
    display_data(processed)
    
    # Show statistics
    stats = calculate_statistics(processed)
    console.print("\n[cyan]Statistics:[/cyan]")
    for key, value in stats.items():
        console.print(f"  {key}: {value}")


def main() -> None:
    """Main entry point for the CLI."""
    cli()


if __name__ == "__main__":
    main()
