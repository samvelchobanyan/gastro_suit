export interface BadgeProps {
  /** Numeric count shown in the circle. Clamps to `max` (e.g. 99+). */
  count?: number;
  max?: number;
  /** 'default' (error fill) or 'empty' (tonal fill, accent number + 1px accent border). */
  variant?: 'default' | 'empty';
  /** Element to overlay the badge onto (e.g. an icon). Standalone if omitted. */
  children?: React.ReactNode;
}

export function Badge(props: BadgeProps): JSX.Element;
