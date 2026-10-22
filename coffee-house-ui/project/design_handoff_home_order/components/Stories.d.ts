export interface StoriesProps {
  /** Story cover / avatar image URL. */
  imageUrl?: string | null;
  /** Label shown beneath the ring. */
  label?: string;
  /** Seen state — grey ring when true, brand-color ring when false. */
  seen?: boolean;
  /** Diameter of the ring in px. Default 64. */
  size?: number;
  onClick?: () => void;
}

export function Stories(props: StoriesProps): JSX.Element;
