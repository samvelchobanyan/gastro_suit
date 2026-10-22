export interface SizeSelectorProps {
  /** Size label, e.g. "Regular", "Large". */
  name?: string;
  /** Pre-formatted price string, e.g. "$4.50". */
  price?: string;
  selected?: boolean;
  onClick?: () => void;
}

export function SizeSelector(props: SizeSelectorProps): JSX.Element;
