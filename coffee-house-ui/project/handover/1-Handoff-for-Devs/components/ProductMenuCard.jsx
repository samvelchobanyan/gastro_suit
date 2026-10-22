import React from 'react';

/**
 * ProductMenuCard — a self-contained menu card with a gray-50 background,
 * padding, and rounded corners. Photo on top, product name (Body Small),
 * then price (Body Small Semibold). 160px wide by default.
 */
export function ProductMenuCard({
  name = 'Product name',
  price = '',
  imageUrl = null,
  width = 160,
  onClick = () => {},
}) {
  return (
    <button type="button" onClick={onClick} style={{
      boxSizing: 'border-box', width, padding: 0, border: 'none', overflow: 'hidden',
      background: 'var(--gray-900)', borderRadius: 'var(--radius-md)', cursor: 'pointer',
      textAlign: 'left', fontFamily: 'var(--font-family-base)',
      display: 'flex', flexDirection: 'column', WebkitTapHighlightColor: 'transparent',
    }}>
      {imageUrl ? (
        <img src={imageUrl} alt="" style={{ width, height: width, objectFit: 'cover', display: 'block' }} />
      ) : (
        <div aria-hidden="true" style={{
          width, height: width,
          background: 'repeating-linear-gradient(45deg, var(--gray-100), var(--gray-100) 8px, var(--gray-200) 8px, var(--gray-200) 16px)',
        }} />
      )}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--space-xxs)', padding: 'var(--space-sm)' }}>
        <span style={{ fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', fontWeight: 'var(--font-weight-semibold)', fontFamily: 'var(--font-family-base)', color: 'var(--gray-0)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{name}</span>
        <span style={{ fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)', fontFamily: 'var(--font-family-base)', color: 'var(--gray-0)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{price}</span>
      </div>
    </button>
  );
}
