import React from 'react';

/**
 * Voucher — reward/coupon list row: square product image placeholder on
 * the left (swappable per client), product name (Body Regular) and a
 * remaining-count line (Body Small) beside it.
 */
export function Voucher({
  name = 'Voucher',
  remaining = 0,
  image = null,       // per-client product image URL; placeholder when null
}) {
  return (
    <div style={{
      boxSizing: 'border-box', width: 'fit-content', maxWidth: 328, padding: 'var(--space-md)',
      borderRadius: 'var(--space-base)', background: 'var(--gray-100)', paddingRight: 'var(--space-base)',
      fontFamily: 'var(--font-family-base)', display: 'flex', alignItems: 'center', gap: 'var(--space-md)',
    }}>
      {image ? (
        <img src={image} alt="" style={{ flex: '0 0 auto', width: 48, height: 48, borderRadius: 'var(--radius-sm)', objectFit: 'cover' }} />
      ) : (
        <span aria-hidden="true" style={{
          flex: '0 0 auto', width: 48, height: 48, borderRadius: 'var(--radius-sm)',
          background: 'repeating-linear-gradient(45deg, rgba(0,0,0,0.05) 0 8px, rgba(0,0,0,0) 8px 16px), var(--color-bg-muted)',
        }} />
      )}
      <div style={{ flex: '0 1 auto', minWidth: 0, display: 'flex', flexDirection: 'column', gap: 'var(--space-xxs)' }}>
        <span style={{ fontSize: 'var(--font-size-body)', lineHeight: 'var(--line-height-body)', fontWeight: 'var(--font-weight-regular)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-primary)', whiteSpace: 'nowrap' }}>{name}</span>
        <span style={{ fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', fontWeight: 'var(--font-weight-regular)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-tertiary)' }}>{remaining} remaining</span>
      </div>
    </div>
  );
}
