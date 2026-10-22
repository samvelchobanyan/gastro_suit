export interface ButtonProps {
  children?: React.ReactNode;
  /** Visual role. Default `primary`. */
  variant?: 'primary' | 'secondary' | 'tertiary' | 'destructive';
  /** Height: lg 56 · md 48 (default) · sm 40 · xs 32. */
  size?: 'lg' | 'md' | 'sm' | 'xs';
  /** Stretch to container width (full-width CTA). */
  fullWidth?: boolean;
  disabled?: boolean;
  /** Freezes size, hides label, shows a centered spinner. */
  loading?: boolean;
  /** Phosphor icon name shown before the label (e.g. `shopping-cart-simple`). */
  iconLeft?: string;
  /** Phosphor icon name shown after the label. */
  iconRight?: string;
  onClick?: (e: React.MouseEvent) => void;
  type?: 'button' | 'submit' | 'reset';
  /** Corner radius override. Default `md` (`sm` at xs size). `full` = pill. */
  radius?: 'sm' | 'md' | 'lg' | 'full';
  ariaLabel?: string;
}

export function Button(props: ButtonProps): JSX.Element;
