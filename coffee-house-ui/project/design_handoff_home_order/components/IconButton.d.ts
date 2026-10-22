export interface IconButtonProps {
  /** Phosphor icon name (e.g. `heart`, `share-network`, `x`). */
  icon?: string;
  /** `ghost` (transparent), `filled` (accent), `tonal` (subtle tint). */
  variant?: 'ghost' | 'filled' | 'tonal';
  /** Hit-target size: xxs 24 · xs 28 · sm 40 · md 48 (default) · lg 56. */
  size?: 'xxs' | 'xs' | 'sm' | 'md' | 'lg';
  disabled?: boolean;
  /** Selected/active (e.g. favorited) — ghost variant fills the glyph. */
  active?: boolean;
  onClick?: (e: React.MouseEvent) => void;
  /** Required for accessibility — the control is icon-only. */
  ariaLabel?: string;
}

export function IconButton(props: IconButtonProps): JSX.Element;
