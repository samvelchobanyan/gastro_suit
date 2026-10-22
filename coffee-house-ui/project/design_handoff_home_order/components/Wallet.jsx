import React from 'react';
import { Button } from '../buttons/Button.jsx';

/**
 * Wallet — fixed-width 328px dark balance card showing a wallet icon,
 * title, balance, and a "Top Up" action.
 */
export function Wallet({ title = 'Wallet balance', balance = '$0.00', icon = null, topUpLabel = 'Top up', onTopUp = () => {} }) {
  return (
    <div style={{
      width: 328, boxSizing: 'border-box', borderRadius: 'var(--radius-lg)', background: 'var(--gray-900)',
      padding: 'var(--space-base)', display: 'flex', alignItems: 'center', gap: 'var(--space-md)',
      fontFamily: 'var(--font-family-base)',
    }}>
      <div style={{ width: 48, height: 48, borderRadius: 'var(--radius-sm)', overflow: 'hidden', flexShrink: 0 }}>
        {icon && <img src={icon} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />}
      </div>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
        <span style={{ fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', color: 'var(--gray-500)' }}>{title}</span>
        <span style={{ fontSize: 'var(--font-size-h1)', lineHeight: 'var(--line-height-h1)', color: 'var(--gray-0)', fontWeight: 'var(--font-weight-bold)' }}>{balance}</span>
      </div>
      <Button size="xs" radius="full" iconLeft="plus" onClick={onTopUp}>{topUpLabel}</Button>
    </div>
  );
}
