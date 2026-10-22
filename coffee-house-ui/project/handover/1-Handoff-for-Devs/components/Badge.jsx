import React from 'react';

/**
 * Badge — number in a circle, overlaid on a child element (e.g. an icon).
 * Counts clamp at `max` (default 99 -> "99+").
 */
export function Badge({
  count = 0,
  max = 99,
  children = null,
  variant = 'default', // 'default' | 'empty'
  style = null,
}) {
  const label = count > max ? `${max}+` : count;

  const pill = {
    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
    minWidth: 18, height: 18, padding: '0 5px',
    boxSizing: 'border-box',
    background: variant === 'empty' ? 'var(--color-brand-subtle)' : 'var(--color-status-error)',
    color: variant === 'empty' ? 'var(--color-text-accent)' : 'var(--color-text-on-brand)',
    border: variant === 'empty' ? '1px solid var(--color-brand-primary)' : 'none',
    borderRadius: 'var(--radius-full)', fontFamily: 'var(--font-family-base)',
    fontSize: 'var(--font-size-body-xs)', fontWeight: 'var(--font-weight-semibold)', lineHeight: 'var(--line-height-body-xs)',
    fontVariantNumeric: 'tabular-nums',
  };

  if (!children) return <span style={{ ...pill, ...style }} aria-label={String(label)}>{label}</span>;

  return (
    <span style={{ position: 'relative', display: 'inline-flex' }}>
      {children}
      <span style={{ ...pill, position: 'absolute', top: -4, right: -4, ...style }}>
        {label}
      </span>
    </span>
  );
}
