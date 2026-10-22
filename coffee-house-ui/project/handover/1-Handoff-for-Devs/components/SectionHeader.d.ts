export interface SectionHeaderProps {
  title?: string;
  /** Optional trailing action label, e.g. "See all". */
  action?: string | null;
  onActionClick?: (() => void) | null;
}

export function SectionHeader(props: SectionHeaderProps): JSX.Element;
