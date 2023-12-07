# postgres_snils_validate
Функция проверки СНИЛС для PostgreSQL
## Параметры функции validate_snils

| Параметр | Описание |
|--|--|
| snils_input | Строка с номером СНИЛС (только цифры, без разделителей и доп. символов)  |

## Пример использования

    SELECT public.validate_snils('41906668902'); -- true
    SELECT public.validate_snils('41906668999'); -- false
