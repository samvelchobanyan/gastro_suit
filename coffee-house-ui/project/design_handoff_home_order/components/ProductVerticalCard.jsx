import React from 'react';

/**
 * ProductVerticalCard — vertical product card mirroring BuyAgainCard, but
 * the second line is a price (Body Extra Small) instead of a location.
 * Photo on top, product name (Body Small), then price. Swappable placeholder.
 */
export function ProductVerticalCard({
  name = 'Product name',
  price = '',
  imageUrl = null,
  width = 128,
  onClick = () => {},
}) {
  return (
    <button type="button" onClick={onClick} style={{
      boxSizing: 'border-box', width, padding: 0, border: 'none', background: 'transparent',
      cursor: 'pointer', textAlign: 'left', fontFamily: 'var(--font-family-base)',
      display: 'flex', flexDirection: 'column', gap: 'var(--space-sm)', WebkitTapHighlightColor: 'transparent',
    }}>
      {imageUrl ? (
        <img src={imageUrl} alt="" style={{ width: '100%', aspectRatio: '1 / 1', objectFit: 'cover', borderRadius: 'var(--radius-card)', display: 'block' }} />
      ) : (
        <div aria-hidden="true" style={{
          width: '100%', aspectRatio: '1 / 1', borderRadius: 'var(--radius-card)',
          background: 'repeating-linear-gradient(45deg, var(--gray-100), var(--gray-100) 8px, var(--gray-200) 8px, var(--gray-200) 16px)',
        }} />
      )}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--space-xxs)' }}>
        <span style={{ fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', fontWeight: 'var(--font-weight-semibold)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-primary)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{name}</span>
        <span style={{ fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-secondary)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{price}</span>
      </div>
    </button>
  );
}
