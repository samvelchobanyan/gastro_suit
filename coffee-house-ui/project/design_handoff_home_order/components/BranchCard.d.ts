export interface BranchCardProps {
  image?: string;
  name?: string;
  address?: string;
  /** Working hours string, e.g. "Mon–Sun · 11:00–22:00". */
  hours?: string;
  isOpenNow?: boolean;
  /** Optional distance label, e.g. "1.2 km". */
  distance?: string;
  onClick?: (e: React.MouseEvent) => void;
}

export function BranchCard(props: BranchCardProps): JSX.Element;
