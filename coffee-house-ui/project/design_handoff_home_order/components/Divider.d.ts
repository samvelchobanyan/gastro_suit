export interface DividerProps {
  /** Left inset in px (e.g. align past a list item's leading icon). */
  inset?: number;
  /** Optional centered label ("or"). */
  label?: string;
  /** Vertical 1px rule (stretches to parent height). */
  vertical?: boolean;
}

export function Divider(props: DividerProps): JSX.Element;
