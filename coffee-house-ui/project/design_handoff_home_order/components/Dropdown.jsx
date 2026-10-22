import React from 'react';

/**
 * Dropdown / Select — tappable field that opens a list of selectable
 * options below it, with label, helper/error text, and a caret indicator.
 * Part of the Controls component group.
 */
export function Dropdown({
  label = null,
  value = null,
  options = [],
  placeholder = 'Select…',
  onChange = () => {},
  error = false,
  helperText = null,
  disabled = false,
  size = 'default', // 'default' (48px) | 'floating' (56px)
}) {
  const [open, setOpen] = React.useState(false);
  const selected = options.find((o) => o.value === value) || null;
  const height = size === 'floating' ? 56 : 40;

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--space-xs)', width: '100%', fontFamily: 'var(--font-family-base)' }}>
      {label && (
        <span style={{ fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', fontWeight: 'var(--font-weight-semibold)', color: 'var(--input-label)' }}>{label}</span>
      )}
      <div
        role="button" tabIndex={disabled ? -1 : 0}
        onClick={() => !disabled && setOpen((o) => !o)}
        style={{
          position: 'relative', boxSizing: 'border-box', width: '100%', height,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-sm)',
          padding: '0 var(--space-sm) 0 var(--space-base)', borderRadius: 'var(--radius-input)',
          background: 'var(--input-bg)',
          border: `${open ? 2 : 1}px solid ${error ? 'var(--input-border-error)' : open ? 'var(--input-border-focus)' : 'var(--input-border)'}`,
          cursor: disabled ? 'not-allowed' : 'pointer', opacity: disabled ? 'var(--state-disabled-opacity)' : 1,
        }}
      >
        <span style={{
          flex: 1, minWidth: 0, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
          fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', fontWeight: 'var(--font-weight-regular)',
          color: selected ? 'var(--input-text)' : 'var(--input-placeholder)',
        }}>{selected ? selected.label : placeholder}</span>
        <i className="ph ph-caret-down" aria-hidden="true" style={{
          fontSize: 'var(--icon-sm)', color: 'var(--color-text-tertiary)',
          transform: open ? 'rotate(180deg)' : 'none', transition: 'var(--transition-transform)',
        }} />
        {open && (
          <div style={{
            position: 'absolute', top: 'calc(100% + 4px)', left: 0, right: 0, zIndex: 10,
            background: 'var(--color-bg-surface)', border: '1px solid var(--color-border-muted)',
            borderRadius: 'var(--radius-input)', boxShadow: 'var(--elevation-overlay)',
            padding: 'var(--space-xs)', display: 'flex', flexDirection: 'column', maxHeight: 240, overflowY: 'auto',
          }}>
            {options.map((o) => (
              <div key={o.value}
                onClick={(e) => { e.stopPropagation(); onChange(o.value); setOpen(false); }}
                style={{
                  minHeight: 44, display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 'var(--space-sm)',
                  padding: '0 var(--space-sm)', borderRadius: 'var(--radius-sm)', cursor: 'pointer',
                  background: o.value === value ? 'var(--color-brand-subtle)' : 'transparent',
                  fontSize: 'var(--font-size-body)', lineHeight: 'var(--line-height-body)',
                  fontWeight: 'var(--font-weight-regular)',
                  color: o.value === value ? 'var(--color-text-accent)' : 'var(--color-text-primary)',
                }}
              >
                <span>{o.label}</span>
                {o.value === value && <i className="ph ph-check" aria-hidden="true" style={{ fontSize: 'var(--icon-sm)' }} />}
              </div>
            ))}
          </div>
        )}
      </div>
      {helperText && (
        <span style={{ fontSize: 'var(--font-size-caption)', lineHeight: 'var(--line-height-caption)', color: error ? 'var(--color-text-error)' : 'var(--input-helper)' }}>{helperText}</span>
      )}
    </div>
  );
}
