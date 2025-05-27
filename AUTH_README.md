# Air App - Sistema de Autenticação

Este projeto implementa um sistema completo de autenticação para o Flutter que se conecta à API Backend_Air_App_Users.

## 🚀 Funcionalidades Implementadas

### Autenticação
- ✅ Login de utilizador
- ✅ Registo de novo utilizador
- ✅ Logout (local e do servidor)
- ✅ Refresh token automático
- ✅ Verificação de token
- ✅ Armazenamento seguro de credenciais

### Gestão de Utilizador
- ✅ Visualização de perfil
- ✅ Edição de perfil (nome e sobrenome)
- ✅ Informações da conta (estado, verificação)

### Interface
- ✅ Tela de login moderna
- ✅ Tela de registo completa
- ✅ Tela de perfil interativa
- ✅ Tela inicial com funcionalidades
- ✅ Navegação baseada em estado de autenticação

## 📁 Estrutura do Projeto

```
lib/
├── config/
│   └── app_config.dart          # Configurações da aplicação
├── models/
│   ├── user.dart                # Modelo do utilizador
│   ├── user.g.dart              # Código gerado para JSON
│   ├── auth_response.dart       # Modelos de autenticação
│   └── auth_response.g.dart     # Código gerado para JSON
├── providers/
│   └── auth_provider.dart       # Provider para gestão de estado
├── screens/
│   ├── home_screen.dart         # Tela inicial após login
│   ├── login_screen.dart        # Tela de login
│   ├── profile_screen.dart      # Tela de perfil do utilizador
│   └── register_screen.dart     # Tela de registo
├── services/
│   ├── api_service.dart         # Serviço para comunicação com API
│   ├── auth_service.dart        # Serviço de autenticação
│   └── secure_storage_service.dart # Armazenamento seguro
├── widgets/
│   └── auth_wrapper.dart        # Wrapper para controlo de autenticação
└── main.dart                    # Ponto de entrada da aplicação
```

## 🔧 Configuração

### 1. Dependências
As seguintes dependências foram adicionadas ao `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0                    # Requisições HTTP
  flutter_secure_storage: ^9.0.0 # Armazenamento seguro
  provider: ^6.1.1               # Gestão de estado
  json_annotation: ^4.8.1        # Anotações JSON

dev_dependencies:
  build_runner: ^2.4.7           # Geração de código
  json_serializable: ^6.7.1      # Serialização JSON
```

### 2. API Configuration
Configure a URL da API no ficheiro `lib/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://localhost:3000/api';
```

**Importante**: Para testes em dispositivos físicos ou emuladores, altere `localhost` para o IP da sua máquina.

### 3. Backend Requirements
Certifique-se de que o Backend_Air_App_Users está em execução:

```bash
cd Backend_Air_App_Users
npm run docker:up
```

## 📱 Como Usar

### Registo de Novo Utilizador
1. Abra a aplicação
2. Toque em "Criar conta" na tela de login
3. Preencha todos os campos obrigatórios
4. Toque em "Criar Conta"
5. Após sucesso, volte à tela de login

### Login
1. Insira seu email e senha
2. Toque em "Entrar"
3. Será redirecionado para a tela inicial

### Gestão de Perfil
1. Na tela inicial, toque no avatar no canto superior direito
2. Selecione "Perfil"
3. Toque em "Editar Perfil" para fazer alterações
4. Salve as alterações

### Logout
1. Toque no avatar no canto superior direito
2. Selecione "Sair"
3. Confirme a ação

## 🔒 Segurança

### Armazenamento Seguro
- Tokens são armazenados usando `flutter_secure_storage`
- Encriptação automática no Android e iOS
- Dados protegidos por biometria/PIN do dispositivo

### Gestão de Tokens
- Access tokens com expiração automática
- Refresh tokens para renovação silenciosa
- Logout remove todos os tokens do dispositivo e servidor

### Validação
- Validação de email
- Senha mínima de 6 caracteres
- Username mínimo de 3 caracteres
- Confirmação de senha no registo

## 🌐 Endpoints API Utilizados

### Autenticação
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Registo
- `POST /api/auth/logout` - Logout
- `POST /api/auth/refresh-token` - Renovar token
- `GET /api/auth/verify-token` - Verificar token

### Utilizador
- `GET /api/users/profile` - Obter perfil
- `PUT /api/users/profile` - Atualizar perfil

## 🚀 Próximos Passos

Para expandir o sistema, considere implementar:

1. **Verificação de Email**
   - Tela de verificação
   - Reenvio de email de verificação

2. **Recuperação de Senha**
   - Tela "Esqueci minha senha"
   - Reset de senha por email

3. **Configurações Avançadas**
   - Alterar senha
   - Gestão de sessões ativas
   - Configurações de privacidade

4. **Biometria**
   - Login com impressão digital
   - Face ID/Touch ID

5. **Modo Offline**
   - Cache de dados do utilizador
   - Sincronização quando online

## 🐛 Troubleshooting

### Problemas Comuns

1. **Erro de Conexão**
   - Verifique se o backend está em execução
   - Confirme o URL da API na configuração
   - Para testes em dispositivos físicos, use o IP da máquina

2. **Problemas de Armazenamento Seguro**
   - Certifique-se de que as permissões estão configuradas
   - Em desenvolvimento, limpe o cache da aplicação

3. **Tokens Inválidos**
   - Faça logout e login novamente
   - Verifique se o backend não foi reiniciado

## 📄 Licença

Este projeto está sob a licença MIT.
