import React from 'react';

/**
 * ProductHorizontalCard — horizontal product row mirroring
 * ProductVerticalCard: a small square photo on the left with the product
 * name (Body Small Semibold, wraps up to 2 lines) with an info line and price stacked below it.
 * Image is half the vertical card's width. Swappable placeholder.
 */
export function ProductHorizontalCard({
  name = 'Product name',
  info = '',
  price = '',
  imageUrl = null,
  imageSize = 64,
  onClick = () => {},
}) {
  return (
    <button type="button" onClick={onClick} style={{
      boxSizing: 'border-box', width: '100%', padding: 0, border: 'none', background: 'transparent',
      cursor: 'pointer', textAlign: 'left', fontFamily: 'var(--font-family-base)',
      display: 'flex', alignItems: 'center', gap: 'var(--space-md)', WebkitTapHighlightColor: 'transparent',
    }}>
      {imageUrl ? (
        <img src={imageUrl} alt="" style={{ width: imageSize, height: imageSize, flex: '0 0 auto', objectFit: 'cover', borderRadius: 'var(--radius-md)', display: 'block' }} />
      ) : (
        <div aria-hidden="true" style={{
          width: imageSize, height: imageSize, flex: '0 0 auto', borderRadius: 'var(--radius-md)',
          background: 'repeating-linear-gradient(45deg, var(--gray-100), var(--gray-100) 8px, var(--gray-200) 8px, var(--gray-200) 16px)',
        }} />
      )}
      <div style={{ minWidth: 0, flex: 1, display: 'flex', flexDirection: 'column', gap: 'var(--space-xxs)' }}>
        <span style={{ font: 'var(--text-body-semibold)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-primary)', whiteSpace: 'normal', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>{name}</span>
        {info && <span style={{ fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-tertiary)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{info}</span>}
        <span style={{ fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)', fontFamily: 'var(--font-family-base)', color: 'var(--color-text-secondary)', whiteSpace: 'nowrap' }}>{price}</span>
      </div>
    </button>
  );
}
