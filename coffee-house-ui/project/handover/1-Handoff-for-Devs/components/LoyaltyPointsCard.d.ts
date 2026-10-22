export interface LoyaltyPointsCardProps {
  /** Points balance shown large. */
  points?: number;
  /** Membership tier label passed to MembershipTierPill. */
  membership?: string;
  /** Optional discount amount shown in the tier pill. */
  discountLabel?: string | null;
  /** Value the QR code encodes (member id, redemption code). */
  qrValue?: string;
  /** Optional per-brand background image behind the card content. */
  backgroundImage?: string | null;
}

export function LoyaltyPointsCard(props: LoyaltyPointsCardProps): JSX.Element;
