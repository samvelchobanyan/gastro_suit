import React from 'react';

/**
 * BuyAgainCard — vertical product card for re-order rails: product photo on
 * top, then product name (Body Regular), then location (Body Small). Fixed
 * compact width for horizontal scroll rows. Image is a swappable placeholder.
 */
export function BuyAgainCard({
  name = 'Product name',
  location = 'Location',
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
        <span style={{ display: 'inline-flex', alignItems: 'center', gap: 'var(--space-xs)', fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-secondary)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
          <i className="ph ph-map-pin" aria-hidden="true" style={{ fontSize: 'var(--icon-xs)', flex: '0 0 auto' }} />{location}
        </span>
      </div>
    </button>
  );
}
