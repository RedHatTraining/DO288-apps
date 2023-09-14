/**
 * Component for displaying a loading message.
 * Very simple right now, but could be refactored to match a style guide.
 */
export function Loading(props: { name: string }) {
  return <span>Loading {props.name}...</span>;
}
