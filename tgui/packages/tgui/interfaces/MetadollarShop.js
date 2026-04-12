import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

export const MetadollarShop = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    balance = 0,
    inteqMode = false,
    legit = [],
    smuggle = [],
  } = data;
  const theme = inteqMode ? 'inteq' : 'neutral';
  const catalog = inteqMode ? smuggle : legit;
  return (
    <Window
      width={520}
      height={480}
      theme={theme}
      title="Метамаазин">
      <Window.Content
        scrollable
        style={{
          position: 'relative',
          minHeight: '100%',
        }}>
        <Stack vertical fill>
          <Stack.Item grow>
            <Section
              title="Баланс"
              buttons={(
                <Stack direction="row" align="center">
                  <Stack.Item>
                    <Box color="label">
                      {balance} M$
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="wallet"
                      onClick={() => act('topup')}>
                      ПОПОЛНИТЬ СЧЁТ
                    </Button>
                  </Stack.Item>
                </Stack>
              )}>
              {inteqMode ? (
                <Box>
                  Подпольный каталог: особые заказы для следующей смены.
                </Box>
              ) : (
                <Box>
                  Официальный каталог: снаряжение в рюкзак при появлении на станции.
                </Box>
              )}
            </Section>
            <Section title="Товары">
              <Stack vertical>
                {catalog.map(entry => (
                  <Stack.Item key={entry.id}>
                    <Box mb={1}>
                      <Box bold>{entry.name}</Box>
                      <Box color="label" fontSize={0.9}>
                        {entry.desc}
                      </Box>
                    </Box>
                    <Button
                      fluid
                      icon="cart-plus"
                      color={inteqMode ? 'bad' : 'good'}
                      disabled={balance < entry.cost}
                      content={`Купить за ${entry.cost} M$`}
                      onClick={() => act('buy', { id: entry.id })} />
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
        <Box
          style={{
            position: 'absolute',
            left: '12px',
            bottom: '8px',
            zIndex: 5,
          }}>
          <Button
            compact
            tooltip={inteqMode
              ? 'Вернуться к официальному каталогу'
              : 'Подпольный вход (другой каталог)'}
            icon={inteqMode ? 'building' : 'skull'}
            color={inteqMode ? 'average' : 'bad'}
            onClick={() => act('toggle_smuggle')} />
        </Box>
      </Window.Content>
    </Window>
  );
};
