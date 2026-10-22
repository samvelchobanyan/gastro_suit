/**
 * MenuTabs — horizontal scroll row of pill tabs, each pairing a small
 * category image with a category name. Pills are 44px tall; the active
 * pill fills with the brand color. For scannable menu category switching.
 */
function MenuTabs({
  categories = [],   // [{ label, value, image }]
  value = null,
  onChange = () => {},
}) {
  return (
    <div style={{
      display: 'flex', gap: 'var(--space-sm)', overflowX: 'auto', padding: 'var(--space-xs)',
      WebkitOverflowScrolling: 'touch', fontFamily: 'var(--font-family-base)',
    }}>
      {categories.map((c) => {
        const active = c.value === value;
        return (
          <button key={c.value} type="button" onClick={() => onChange(c.value)} aria-pressed={active}
            style={{
              flex: '0 0 auto', display: 'inline-flex', alignItems: 'center', gap: 'var(--space-sm)',
              boxSizing: 'border-box', padding: 'var(--space-xs) var(--space-md) var(--space-xs) var(--space-xs)',
              border: 'none',
              background: active ? 'var(--color-brand-primary)' : 'var(--gray-900)',
              color: active ? 'var(--color-text-on-brand)' : 'var(--gray-0)',
              borderRadius: 'var(--radius-full)', cursor: 'pointer', WebkitTapHighlightColor: 'transparent',
              transition: 'var(--transition-colors)',
            }}>
            <span aria-hidden="true" style={{
              flex: '0 0 auto', width: 36, height: 36, borderRadius: 'var(--radius-full)', overflow: 'hidden',
              background: c.image ? `center/cover no-repeat url("${c.image}")` : 'var(--color-bg-surface-sunken)',
            }} />
            <span style={{
              fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', fontWeight: 'var(--font-weight-semibold)',
              whiteSpace: 'nowrap',
            }}>{c.label}</span>
          </button>
        );
      })}
    </div>
  );
}

module.exports = { MenuTabs };
