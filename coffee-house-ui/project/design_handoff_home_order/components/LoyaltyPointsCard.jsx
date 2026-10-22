import React from 'react';
import { MembershipTierPill } from './MembershipTierPill.jsx';

/**
 * LoyaltyPointsCard — fixed 328×116 dark membership card showing points
 * balance, tier pill, and a scannable QR code, with an optional per-brand
 * background image.
 */
export function LoyaltyPointsCard({
  points = 0,
  membership = 'Regular',
  discountLabel = null,
  qrValue = '',
  backgroundImage = null,
}) {
  return (
    <div style={{
      position: 'relative', width: 328, height: 116, boxSizing: 'border-box',
      borderRadius: 'var(--radius-lg)', background: 'var(--gray-900)', overflow: 'hidden',
      padding: 'var(--space-base) var(--space-lg) var(--space-base) var(--space-base)', display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      fontFamily: 'var(--font-family-base)',
    }}>
      {backgroundImage && (
        <img src={backgroundImage} alt="" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', objectFit: 'cover' }} />
      )}
      <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'flex-start', gap: 0 }}>
        <span style={{ fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', color: 'var(--gray-500)' }}>Loyalty points</span>
        <span style={{ fontSize: 'var(--font-size-h1)', lineHeight: 'var(--line-height-h1)', color: 'var(--gray-0)', fontWeight: 'var(--font-weight-bold)' }}>{points}</span>
        <div style={{ marginTop: 'var(--space-xs)' }}>
          <MembershipTierPill membership={membership} discountLabel={discountLabel} />
        </div>
      </div>
      <img src="./qr-code.svg" alt={qrValue ? `QR code for ${qrValue}` : 'QR code'} style={{ position: 'relative', width: 68, height: 68, display: 'block' }} />
    </div>
  );
}
