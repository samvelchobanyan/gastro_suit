export interface WalletProps {
  /** Small label above the balance. */
  title?: string;
  /** Formatted balance string, e.g. "$42.50". */
  balance?: string;
  /** Optional icon/image URL. */
  icon?: string | null;
  /** Top-up button label. */
  topUpLabel?: string;
  onTopUp?: () => void;
}

export function Wallet(props: WalletProps): JSX.Element;
