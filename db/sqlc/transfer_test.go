package db

import (
	"context"
	"github.com/stretchr/testify/require"
	"github.com/techschool/simplebank/util"
	"testing"
)

func createRandomTransfer(t *testing.T, accountFrom Account) Transfer {
	accountTo := createRandomAccount(t)

	arg := CreateTransferParams{
		FromAccountID: accountFrom.ID,
		ToAccountID:   accountTo.ID,
		Amount:        util.RandomMoney(),
	}

	transfer, err := testQueries.CreateTransfer(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, transfer)

	require.Equal(t, arg.FromAccountID, transfer.FromAccountID)
	require.Equal(t, arg.ToAccountID, transfer.ToAccountID)
	require.Equal(t, arg.Amount, transfer.Amount)
	require.NotZero(t, transfer.CreatedAt)
	require.NotZero(t, transfer.ID)

	return transfer
}

func TestQueries_CreateTransfer(t *testing.T) {
	createRandomTransfer(t, createRandomAccount(t))
}

func TestQueries_GetTransfer(t *testing.T) {

	transfer1 := createRandomTransfer(t, createRandomAccount(t))
	transfer2, err := testQueries.GetTransfer(context.Background(), transfer1.ID)

	require.NoError(t, err)
	require.NotEmpty(t, transfer2)

	require.Equal(t, transfer1.ID, transfer2.ID)
	require.Equal(t, transfer1.FromAccountID, transfer2.FromAccountID)
	require.Equal(t, transfer1.ToAccountID, transfer2.ToAccountID)
	require.Equal(t, transfer1.Amount, transfer2.Amount)
	require.Equal(t, transfer1.CreatedAt, transfer2.CreatedAt)

}

func TestQueries_ListTransfers(t *testing.T) {
	accountFrom := createRandomAccount(t)

	for i := 0; i < 10; i++ {
		createRandomTransfer(t, accountFrom)
	}

	arg := ListTransfersParams{
		FromAccountID: accountFrom.ID,
		Limit:         5,
		Offset:        5,
	}

	transfers, err := testQueries.ListTransfers(context.Background(), arg)

	require.NoError(t, err)
	require.Len(t, transfers, 5)

	for _, transfer := range transfers {
		require.NotEmpty(t, transfer)
	}
}
