import React from 'react';

/**
 * MenuTabsVertical — horizontal scroll row of category items, each stacking
 * a round category image with its label beneath (no pill). The active item's
 * image gets a brand-color ring and its label goes accent. For scannable
 * menu category switching where a lighter, container-free treatment is wanted.
 */
export function MenuTabsVertical({
  categories = [],   // [{ label, value, image }]
  value = null,
  onChange = () => {},
}) {
  return (
    <div style={{
      display: 'flex', gap: 'var(--space-md)', overflowX: 'auto', padding: 'var(--space-xs)',
      WebkitOverflowScrolling: 'touch', fontFamily: 'var(--font-family-base)',
    }}>
      {categories.map((c) => {
        const active = c.value === value;
        return (
          <button key={c.value} type="button" onClick={() => onChange(c.value)} aria-pressed={active}
            style={{
              flex: '0 0 auto', display: 'inline-flex', flexDirection: 'column', alignItems: 'center', gap: 'var(--space-xs)',
              width: 64, border: 'none', background: 'transparent', cursor: 'pointer', padding: 0,
              WebkitTapHighlightColor: 'transparent',
            }}>
            <span aria-hidden="true" style={{
              flex: '0 0 auto', width: 56, height: 56, overflow: 'hidden',
              boxSizing: 'border-box',
              border: 'none',
              background: c.image ? `center/cover no-repeat url("${c.image}")` : 'var(--color-bg-surface-sunken)',
              transition: 'var(--transition-colors)',
            }} />
            <span style={{
              fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)',
              fontWeight: active ? 'var(--font-weight-semibold)' : 'var(--font-weight-regular)',
              color: active ? 'var(--color-text-accent)' : 'var(--color-text-secondary)',
              maxWidth: 64, textAlign: 'center', whiteSpace: 'pre-line',
            }}>{c.label.split(' ').length === 2 ? c.label.replace(' ', '\n') : c.label}</span>
          </button>
        );
      })}
    </div>
  );
}
