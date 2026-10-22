import React from 'react';

/**
 * SectionHeader — Heading 2 styled label used to introduce a page section
 * (e.g. "Popular near you", "Your orders").
 */
export function SectionHeader({ title = '', action = null, onActionClick = null }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-md)', width: '100%', boxSizing: 'border-box', fontFamily: 'var(--font-family-base)' }}>
      <span style={{ fontSize: 'var(--font-size-h3)', color: 'var(--color-text-primary)', lineHeight: 'var(--line-height-h3)', fontWeight: 'var(--font-weight-bold)', fontFamily: 'var(--font-family-base)' }}>{title}</span>
      {action && (
        <button type="button" onClick={onActionClick} style={{ background: 'none', border: 'none', padding: 0, cursor: 'pointer', fontSize: 'var(--font-size-body)', fontWeight: 'var(--font-weight-semibold)', color: 'var(--color-brand-primary)', fontFamily: 'inherit' }}>{action}</button>
      )}
    </div>
  );
}
