export interface MenuTabVerticalItem {
  label: string;
  value: string;
  /** Category image URL. Placeholder when omitted. */
  image?: string;
}

export interface MenuTabsVerticalProps {
  /** Category items, each with an image + name stacked vertically. */
  categories?: MenuTabVerticalItem[];
  /** Selected category value. */
  value?: string | null;
  onChange?: (value: string) => void;
}

export function MenuTabsVertical(props: MenuTabsVerticalProps): JSX.Element;
